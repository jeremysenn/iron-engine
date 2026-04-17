# frozen_string_literal: true

# Seeds realistic demo data under a dedicated test coach.
#
# Prerequisites: KILO reference data must already be imported (rake seed:from_csv).
#
# Usage:  rails runner 'load "db/seeds/demo_data.rb"'
#    or:  called from db/seeds.rb
#
# Idempotency: skips clients that already exist (matched by coach + first/last name).
#              If a client exists but has no active program, regenerates the program.

puts "=== Seeding demo data ==="

# ── Guard: KILO reference data must exist ──────────────────────────────

unless KiloPeriodizationModel.any? && KiloExercise.any? && KiloRepIntensityTable.any?
  abort <<~MSG
    [ABORT] KILO reference data is missing.
    Run `rake seed:from_csv` first, then re-run this seed.
  MSG
end

# ── Test Coach ─────────────────────────────────────────────────────────

DEMO_COACH_EMAIL = "demo@ironengine.test"
DEMO_COACH_PASSWORD = "DemoCoach2026!"

coach = User.find_or_initialize_by(email_address: DEMO_COACH_EMAIL)
if coach.new_record?
  coach.password = DEMO_COACH_PASSWORD
  coach.password_confirmation = DEMO_COACH_PASSWORD
  coach.save!
  puts "  Created demo coach: #{DEMO_COACH_EMAIL}"
else
  puts "  Demo coach already exists: #{DEMO_COACH_EMAIL}"
end

# ── Helpers ────────────────────────────────────────────────────────────

# Creates a PrimeEight assessment with lifts and runs the ratio calculator
# to persist StrengthRatioAnalysis records (matching controller behavior).
def create_prime_eight_assessment!(client, lifts_data)
  assessment = client.prime_eight_assessments.create!(assessed_at: Time.current)

  lifts_data.each do |exercise, attrs|
    weight = attrs[:weight].to_f
    reps = attrs[:reps].to_i

    if reps == 1
      e1rm = weight
    elsif reps <= 20
      intensity = KiloRepIntensityTable.lookup(reps)
      e1rm = intensity ? (weight / (intensity / 100.0)).round(1) : weight
    else
      e1rm = (weight * (1 + 0.0333 * reps)).round(1)
    end

    assessment.prime_eight_lifts.create!(
      exercise: exercise,
      weight: weight,
      reps: reps,
      e1rm: e1rm,
      formula_used: reps <= 20 ? :kilo_table : :epley
    )
  end

  # Run ratio calculator and persist analyses (same as controller does)
  calculator = Kilo::StrengthRatioCalculator.new
  ratio_result = calculator.call(assessment.reload)

  ratio_result.ratios.each do |exercise, data|
    data[:lift].create_strength_ratio_analysis!(
      current_ratio: data[:current_ratio],
      optimal_ratio: data[:optimal_ratio],
      discrepancy: data[:discrepancy],
      is_limiting: (exercise == ratio_result.limiting_upper || exercise == ratio_result.limiting_lower)
    )
  end

  puts "    PrimeEight assessment created (#{lifts_data.size} lifts)"
  assessment
end

# Creates a MAP assessment with progressions.
def create_map_assessment!(client, progressions_data)
  assessment = client.map_assessments.create!(assessed_at: Time.current)

  progressions_data.each do |pattern, attrs|
    assessment.map_progressions.create!(
      movement_pattern: pattern.to_s,
      level: attrs[:level],
      passed: attrs[:passed],
      exercise_name: attrs[:exercise_name]
    )
  end

  puts "    MAP assessment created (#{progressions_data.size} patterns)"
  assessment
end

# Stamps training history onto a program's sessions.
#
# mode: :full  — logs ALL sessions (for archived/completed programs)
#        :partial — logs only first N sessions (for in-progress current programs)
#
# start_date: the date the first session was completed
# session_count: only used in :partial mode
#
# Weights progress over time: each exercise gets a stable baseline that increases
# ~2-5% across the program to simulate progressive overload.
#
def stamp_training_history!(program, mode: :partial, session_count: 3, start_date: nil)
  all_sessions = program
    .macrocycles.order(:number)
    .flat_map { |mc| mc.mesocycles.order(:number) }
    .flat_map { |meso| meso.microcycles.order(:week_number) }
    .flat_map { |micro| micro.training_sessions.order(:day) }

  # Skip sessions with no exercises (e.g., empty full_body novice sessions)
  loggable = all_sessions.select { |s| s.session_exercises.any? }

  sessions_to_log = case mode
  when :full then loggable
  when :partial then loggable.first(session_count)
  end

  return if sessions_to_log.empty?

  # Determine dates: space sessions across realistic training days
  freq = program.frequency
  base = start_date || 2.weeks.ago.to_date

  # Per-exercise weight baselines (stable across the program, built on first encounter)
  exercise_baselines = {}

  total = sessions_to_log.size
  sessions_to_log.each_with_index do |session, idx|
    # Schedule: advance by training day spacing based on frequency
    # e.g., 4x/week ≈ every 1-2 days; 3x/week ≈ every 2-3 days
    day_offset = case freq
    when 4 then (idx * 1.75).round
    when 3 then (idx * 2.33).round
    when 2 then (idx * 3.5).round
    else (idx * 1.75).round
    end
    session_date = base + day_offset.days
    session.update!(completed_at: session_date)

    # Progress factor: 0.0 at start → 1.0 at end of program
    progress = total > 1 ? idx.to_f / (total - 1) : 0.0

    session.session_exercises.includes(:exercise_sets).each do |se|
      ex_name = se.exercise_name.to_s

      # Establish a stable baseline on first encounter
      exercise_baselines[ex_name] ||= begin
        target = se.exercise_sets.first&.target_weight.to_f
        target > 0 ? target : realistic_weight_for(ex_name)
      end

      baseline = exercise_baselines[ex_name]
      # Progressive overload: weight increases ~5% across the full program
      progressed_weight = (baseline * (1.0 + 0.05 * progress)).round(1)

      se.exercise_sets.each do |es|
        # Small per-set variance: +/- 2.5 lbs
        actual_weight = (progressed_weight + rand(-1..1) * 2.5).round(1)
        actual_weight = [ actual_weight, 5.0 ].max

        target_reps = es.target_reps.to_i
        # Hit target reps most of the time, occasionally 1 under
        actual_reps = [ target_reps + rand(-1..0), 1 ].max

        es.update!(actual_weight: actual_weight, actual_reps: actual_reps)
      end
    end
  end

  logged_count = sessions_to_log.size
  span_days = sessions_to_log.size > 1 ? (sessions_to_log.last.completed_at - sessions_to_log.first.completed_at).to_i : 0
  puts "    Stamped #{logged_count} sessions (#{base} → #{base + span_days.days}, #{mode})"
end

# Returns a realistic starting weight (lbs) for an exercise name.
def realistic_weight_for(exercise_name)
  name = exercise_name.to_s.downcase
  case
  when name.include?("squat")         then rand(135..225)
  when name.include?("deadlift")      then rand(185..275)
  when name.include?("bench press")   then rand(135..205)
  when name.include?("overhead press") || name.include?("ohp") then rand(85..135)
  when name.include?("incline")       then rand(105..165)
  when name.include?("dip")           then rand(0..45) # bodyweight + plate
  when name.include?("chin") || name.include?("pull") then rand(0..35)
  when name.include?("row")           then rand(95..155)
  when name.include?("curl")          then rand(25..55)
  when name.include?("extension")     then rand(20..45)
  when name.include?("lateral raise") || name.include?("raise") then rand(10..25)
  when name.include?("lunge") || name.include?("split squat") then rand(65..115)
  when name.include?("step")          then rand(50..95)
  when name.include?("goodmorning")   then rand(65..115)
  when name.include?("leg press")     then rand(225..365)
  when name.include?("press")         then rand(95..155)
  else rand(45..95)
  end.to_f
end

# Generates a program using ProgramGenerator.
# Skips only if the client already has an active program matching the intended
# goal and macrocycle_number (so prior programs don't block the current one).
def generate_program!(client, params)
  existing = client.active_program
  if existing &&
     existing.goal == params[:goal].to_s &&
     existing.macrocycle_number == (params[:macrocycle_number] || 1)
    puts "    Active program already exists (#{existing.goal}, macrocycle #{existing.macrocycle_number}) — skipping"
    return existing
  end

  generator = Kilo::ProgramGenerator.new
  program = generator.call(**params)
  puts "    Program generated: #{params[:goal]} / #{params[:volume]} / #{params[:frequency]}x per week (macrocycle #{params[:macrocycle_number] || 1})"
  program
end

# ── Default loading strategies (mesocycle number → strategy) ───────────

DEFAULT_LOADING = {
  1 => "ascending",    # Accumulation 1
  2 => "descending",   # Intensification 1
  3 => "ascending",    # Accumulation 2
  4 => "peaking"       # Intensification 2
}.freeze

# ── MAP Progression Data ──────────────────────────────────────────────
# Realistic MAP assessment results matching the 15 controller-defined patterns.

# Intermediate client: mix of passes and fails to trigger MAP regressions
MAP_DATA_INTERMEDIATE = {
  trunk_stability:     { level: 0, passed: true,  exercise_name: nil },
  squat:              { level: 3, passed: true,  exercise_name: nil },
  deadlift:           { level: 2, passed: true,  exercise_name: nil },
  split_squat:        { level: 2, passed: true,  exercise_name: nil },
  seated_goodmorning: { level: 3, passed: false, exercise_name: nil },
  step_up:            { level: 2, passed: true,  exercise_name: nil },
  ankle_dorsiflexion: { level: 0, passed: true,  exercise_name: nil },
  dip:                { level: 0, passed: false, exercise_name: "rom" },
  chin_up:            { level: 0, passed: true,  exercise_name: nil },
  overhead_press:     { level: 3, passed: true,  exercise_name: nil },
  row:                { level: 3, passed: false, exercise_name: nil },
  push_up:            { level: 3, passed: true,  exercise_name: nil },
  external_rotation:  { level: 0, passed: false, exercise_name: "both_rom" },
  trap_3_raise:       { level: 0, passed: false, exercise_name: nil },
  prone_lateral_raise: { level: 0, passed: true, exercise_name: nil }
}.freeze

# Advanced client: passes most at high levels
MAP_DATA_ADVANCED = {
  trunk_stability:     { level: 0, passed: true,  exercise_name: nil },
  squat:              { level: 4, passed: true,  exercise_name: nil },
  deadlift:           { level: 3, passed: true,  exercise_name: nil },
  split_squat:        { level: 3, passed: true,  exercise_name: nil },
  seated_goodmorning: { level: 3, passed: true,  exercise_name: nil },
  step_up:            { level: 3, passed: true,  exercise_name: nil },
  ankle_dorsiflexion: { level: 0, passed: true,  exercise_name: nil },
  dip:                { level: 0, passed: true,  exercise_name: nil },
  chin_up:            { level: 0, passed: true,  exercise_name: nil },
  overhead_press:     { level: 3, passed: true,  exercise_name: nil },
  row:                { level: 3, passed: true,  exercise_name: nil },
  push_up:            { level: 3, passed: true,  exercise_name: nil },
  external_rotation:  { level: 0, passed: true,  exercise_name: nil },
  trap_3_raise:       { level: 0, passed: true,  exercise_name: nil },
  prone_lateral_raise: { level: 0, passed: true, exercise_name: nil }
}.freeze

# ── PrimeEight Lift Data ──────────────────────────────────────────────
# Realistic strength numbers. Ratios are tuned so the calculator identifies
# the intended limiting lift.

# Client 4: lower-body limiting (front_squat clearly weakest in lower region)
PRIME_EIGHT_LOWER_LIMITING = {
  squat:          { weight: 275, reps: 5 },
  front_squat:    { weight: 155, reps: 5 },  # Deliberately low → limiting lower
  deadlift:       { weight: 315, reps: 5 },
  bench_press:    { weight: 205, reps: 5 },
  overhead_press: { weight: 115, reps: 5 },
  incline_press:  { weight: 155, reps: 5 },
  dip:            { weight: 225, reps: 5 },  # BW + load
  chin_up:        { weight: 200, reps: 5 }  # BW + load
}.freeze

# Client 5: upper-body limiting (overhead_press clearly weakest in upper region)
PRIME_EIGHT_UPPER_LIMITING = {
  squat:          { weight: 265, reps: 5 },
  front_squat:    { weight: 215, reps: 5 },
  deadlift:       { weight: 305, reps: 5 },
  bench_press:    { weight: 195, reps: 5 },
  overhead_press: { weight: 75,  reps: 5 },  # Deliberately low → limiting upper
  incline_press:  { weight: 145, reps: 5 },
  dip:            { weight: 215, reps: 5 },
  chin_up:        { weight: 185, reps: 5 }
}.freeze

# Client 6: OSR novice — moderate numbers, small imbalances (no extreme gaps)
# Ratios verified:
#   squat 185 → E1RM 217.6  | front_squat 150 → 176.5 (81.1%, opt 85%, disc -3.9%)
#   deadlift 230 → 270.6 (124.4%, opt 125%, disc -0.6%)
#   bench 145 → E1RM 170.6  | OHP 105 → 123.5 (72.4%, opt 72%, disc +0.4%)
#   incline 130 → 152.9 (89.6%, opt 91%, disc -1.4%)
#   dip 165 → 194.1 (113.8%, opt 117%, disc -3.2%)
#   chin_up 125 → 147.1 (86.2%, opt 87%, disc -0.8%)
PRIME_EIGHT_NOVICE_OSR = {
  squat:          { weight: 185, reps: 5 },
  front_squat:    { weight: 150, reps: 5 },
  deadlift:       { weight: 230, reps: 5 },
  bench_press:    { weight: 145, reps: 5 },
  overhead_press: { weight: 105, reps: 5 },
  incline_press:  { weight: 130, reps: 5 },
  dip:            { weight: 165, reps: 5 },
  chin_up:        { weight: 125, reps: 5 }
}.freeze

# ── Client Definitions ─────────────────────────────────────────────────
# Each client has a `prior_programs` array (generated first, then auto-archived
# by ProgramGenerator when the next one is created). The current active program
# is defined at the top level.

CLIENTS = [
  # 1. Balanced + MAP (intermediate)
  #    Prior: macrocycle 1 balanced without MAP, then current macrocycle 2 with MAP
  {
    first_name: "Alex", last_name: "Reeves",
    training_age: :intermediate,
    goal: :balanced, volume: :medium, frequency: 4,
    macrocycle_number: 2,
    assessment_type: :map,
    map_data: MAP_DATA_INTERMEDIATE,
    history_sessions: 3,
    prior_programs: [
      { goal: :balanced, volume: :medium, frequency: 4, macrocycle_number: 1,
        use_map: false, history_sessions: 4 }
    ]
  },
  # 2. Balanced + no assessment (novice)
  #    Prior: macrocycle 1 balanced low volume 3x
  {
    first_name: "Jordan", last_name: "Blair",
    training_age: :novice,
    goal: :balanced, volume: :low, frequency: 3,
    macrocycle_number: 2,
    assessment_type: :none,
    history_sessions: 2,
    prior_programs: [
      { goal: :balanced, volume: :low, frequency: 3, macrocycle_number: 1,
        use_map: false, history_sessions: 3 }
    ]
  },
  # 3. Balanced advanced + MAP
  #    Prior: two prior macrocycles (1 and 2), current is macrocycle 3
  {
    first_name: "Morgan", last_name: "Hayes",
    training_age: :advanced,
    goal: :balanced, volume: :high, frequency: 4,
    macrocycle_number: 3,
    assessment_type: :map,
    map_data: MAP_DATA_ADVANCED,
    history_sessions: 3,
    prior_programs: [
      { goal: :balanced, volume: :high, frequency: 4, macrocycle_number: 1,
        use_map: true, history_sessions: 4 },
      { goal: :balanced, volume: :high, frequency: 4, macrocycle_number: 2,
        use_map: true, history_sessions: 4 }
    ]
  },
  # 4. OSR + lower-body limiting lift (intermediate)
  #    Prior: balanced program before switching to OSR
  {
    first_name: "Taylor", last_name: "Park",
    training_age: :intermediate,
    goal: :optimizing_strength_ratios, volume: :medium, frequency: 4,
    assessment_type: :osr,
    osr_data: PRIME_EIGHT_LOWER_LIMITING,
    history_sessions: 2,
    prior_programs: [
      { goal: :balanced, volume: :medium, frequency: 4, macrocycle_number: 1,
        use_map: false, history_sessions: 4 }
    ]
  },
  # 5. OSR + upper-body limiting lift (intermediate)
  #    Prior: balanced program before switching to OSR
  {
    first_name: "Casey", last_name: "Nolan",
    training_age: :intermediate,
    goal: :optimizing_strength_ratios, volume: :medium, frequency: 4,
    assessment_type: :osr,
    osr_data: PRIME_EIGHT_UPPER_LIMITING,
    history_sessions: 2,
    prior_programs: [
      { goal: :balanced, volume: :medium, frequency: 4, macrocycle_number: 1,
        use_map: false, history_sessions: 4 }
    ]
  },
  # 6. OSR novice — no extreme imbalance
  #    Prior: balanced novice program
  #    Note: frequency 4 (not 3) — OSR generator has a known bug with 3x/week
  {
    first_name: "Riley", last_name: "Quinn",
    training_age: :novice,
    goal: :optimizing_strength_ratios, volume: :low, frequency: 4,
    assessment_type: :osr,
    osr_data: PRIME_EIGHT_NOVICE_OSR,
    history_sessions: 1,
    prior_programs: [
      { goal: :balanced, volume: :low, frequency: 4, macrocycle_number: 1,
        use_map: false, history_sessions: 3 }
    ]
  }
].freeze

# ── Seed Each Client ───────────────────────────────────────────────────

CLIENTS.each do |defn|
  puts "\n  Seeding #{defn[:first_name]} #{defn[:last_name]}..."

  client = Client.find_or_initialize_by(
    user: coach,
    first_name: defn[:first_name],
    last_name: defn[:last_name]
  )

  if client.new_record?
    client.training_age = defn[:training_age]
    client.save!
    puts "    Client created (#{defn[:training_age]})"
  else
    puts "    Client already exists"
  end

  # ── Assessment ──

  assessment = nil      # PrimeEight (for ProgramGenerator)
  map_assessment = nil   # MAP (for ProgramGenerator)

  case defn[:assessment_type]
  when :map
    if client.map_assessments.any?
      puts "    MAP assessment already exists — skipping"
      map_assessment = client.map_assessments.last
    else
      map_assessment = create_map_assessment!(client, defn[:map_data])
    end

  when :osr
    if client.prime_eight_assessments.any?
      puts "    PrimeEight assessment already exists — skipping"
      assessment = client.prime_eight_assessments.last
    else
      assessment = create_prime_eight_assessment!(client, defn[:osr_data])
    end
  end

  # ── Prior Programs (archived) ──
  # Generated first so ProgramGenerator auto-archives each one when the next is created.
  # Skipped if client already has archived programs.

  prior_programs = defn[:prior_programs] || []

  # Timeline: each 12-week program spans ~84 days of training.
  # Work backwards from today: current program started recently, prior programs before that.
  # Gap of ~1 week between programs for deload/transition.
  program_span_days = 84  # 12 weeks
  gap_days = 7

  total_prior = prior_programs.size
  # Current program started this many days ago (only a few sessions in)
  current_start = 2.weeks.ago.to_date
  # Prior programs stack backwards from just before the current one
  prior_end_date = current_start - gap_days.days

  if prior_programs.any? && client.programs.archived.none?
    prior_programs.reverse.each_with_index do |prior, reverse_idx|
      idx = total_prior - 1 - reverse_idx
      # Each prior program ends gap_days before the next one starts
      end_date = prior_end_date - (reverse_idx * (program_span_days + gap_days)).days
      start_date = end_date - program_span_days.days

      prior_map = (prior[:use_map] && map_assessment) ? map_assessment : nil
      prior_assessment = (prior[:goal].to_s == "optimizing_strength_ratios") ? assessment : nil

      generator = Kilo::ProgramGenerator.new
      prior_program = generator.call(
        client: client,
        assessment: prior_assessment,
        goal: prior[:goal].to_s,
        volume: prior[:volume].to_s,
        frequency: prior[:frequency],
        macrocycle_number: prior[:macrocycle_number] || 1,
        mesocycle_weeks: [ 3, 3, 3, 3 ],
        map_assessment: prior_map,
        loading_strategies: DEFAULT_LOADING
      )
      puts "    Prior program #{idx + 1} generated: #{prior[:goal]} / macrocycle #{prior[:macrocycle_number] || 1}"

      # Fully log all sessions in archived programs with progressive weights
      stamp_training_history!(prior_program, mode: :full, start_date: start_date)
    end
  elsif prior_programs.any?
    puts "    Archived programs already exist — skipping prior program generation"
  end

  # ── Current Active Program ──

  program = generate_program!(client,
    client: client,
    assessment: assessment,
    goal: defn[:goal].to_s,
    volume: defn[:volume].to_s,
    frequency: defn[:frequency],
    macrocycle_number: defn[:macrocycle_number] || 1,
    mesocycle_weeks: [ 3, 3, 3, 3 ],
    map_assessment: map_assessment,
    loading_strategies: DEFAULT_LOADING
  )

  # ── Training History (current program — partial, recent dates) ──

  if program
    already_logged = program.macrocycles
      .flat_map { |mc| mc.mesocycles }
      .flat_map { |meso| meso.microcycles }
      .flat_map { |micro| micro.training_sessions }
      .any?(&:logged?)

    if already_logged
      puts "    Training history already logged — skipping"
    else
      stamp_training_history!(program, mode: :partial, session_count: defn[:history_sessions], start_date: current_start)
    end
  end
end

puts "\n=== Demo data seeding complete ==="
puts "  Coach login: #{DEMO_COACH_EMAIL} / #{DEMO_COACH_PASSWORD}"
puts "  Clients: #{CLIENTS.size}"
