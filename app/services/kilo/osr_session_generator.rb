# Generates training sessions for Optimizing Strength Ratios programs.
#
# Two modes:
#   1. Template mode (Acc1, Int2): exercises from OsrSessionTemplates,
#      A-series rep scheme from the periodization model, standard B/C defaults.
#   2. Example mode (Int1, Acc2): complete sessions from OsrExampleSessions
#      with training methods, sets, reps, tempo, and rest all pre-specified.
#
# Returns the same SessionBlueprint format as the standard SessionGenerator
# so the program_generator persist! method works unchanged.
#
class Kilo::OsrSessionGenerator
  SessionBlueprint = Kilo::SessionGenerator::SessionBlueprint

  EXAMPLE_PHASES = %i[intensification accumulation_2].freeze

  # @param training_level [Symbol] :novice, :intermediate, :advanced (client.training_age)
  def initialize(training_level:)
    @training_level = training_level
    @osr_level = Kilo::OsrExampleSessions.training_level_for(training_level)
  end

  # Generate sessions for one week of an OSR mesocycle.
  #
  # @param phase [Symbol] :accumulation, :intensification, :accumulation_2, :intensification_2
  # @param seed_phase [Symbol] the seed-data phase key (maps to periodization model row)
  # @param upper_sessions [Array<String>] session types for upper body (from macrocycle template)
  # @param lower_sessions [Array<String>] session types for lower body (from macrocycle template)
  # @param limiting_lift_upper [Symbol] :overhead_press, :incline_press, :bench_press, :dip
  # @param limiting_lift_lower [Symbol] :squat, :front_squat, :deadlift
  # @param rep_scheme [String, nil] A-series rep scheme from periodization model (for template mode)
  # @param frequency [Integer] training frequency (4 = default for OSR)
  # @return [SessionBlueprint]
  def call(phase:, seed_phase:, upper_sessions:, lower_sessions:,
           limiting_lift_upper:, limiting_lift_lower:,
           rep_scheme: nil, frequency: 4)

    # Cap session counts to fit within frequency (templates may provide more
    # sessions than training days, e.g. 2 upper + 2 lower for a 3x program).
    max_upper = [(frequency + 1) / 2, upper_sessions.size].min
    max_lower = [frequency - max_upper, lower_sessions.size].min
    effective_upper = upper_sessions.first(max_upper)
    effective_lower = lower_sessions.first(max_lower)

    sessions = []

    # Build upper body sessions
    effective_upper.each_with_index do |session_type, idx|
      session_label = :"upper_body_#{idx + 1}"
      limiting_lift = limiting_lift_for_session(session_type, limiting_lift_upper, limiting_lift_lower)

      exercises = if example_phase?(phase)
        # Try example first; fall back to template if no example for this session
        build_example_session(limiting_lift, phase, session_label) ||
          build_template_session(limiting_lift, seed_phase, session_label, rep_scheme)
      else
        build_template_session(limiting_lift, seed_phase, session_label, rep_scheme)
      end

      next unless exercises

      sessions << {
        day: upper_day(idx, frequency),
        session_type: normalize_session_type(session_type),
        template_name: session_type.to_s.titleize,
        exercises: exercises,
        estimated_duration: Kilo::RestCalculator.estimate_duration(exercises)
      }
    end

    # Build lower body sessions
    effective_lower.each_with_index do |session_type, idx|
      session_label = :"lower_body_#{idx + 1}"
      limiting_lift = limiting_lift_for_session(session_type, limiting_lift_upper, limiting_lift_lower)

      exercises = if example_phase?(phase)
        # Try example first; fall back to template if no example for this session
        build_example_session(limiting_lift, phase, session_label) ||
          build_template_session(limiting_lift, seed_phase, session_label, rep_scheme)
      else
        build_template_session(limiting_lift, seed_phase, session_label, rep_scheme)
      end

      next unless exercises

      sessions << {
        day: lower_day(idx, frequency),
        session_type: normalize_session_type(session_type),
        template_name: session_type.to_s.titleize,
        exercises: exercises,
        estimated_duration: Kilo::RestCalculator.estimate_duration(exercises)
      }
    end

    result = SessionBlueprint.new(sessions: sessions)
    result.annotate(
      step: "osr_session_generation",
      rule: example_phase?(phase) ? "Example-based (Int1/Acc2)" : "Template + periodization (Acc1/Int2)",
      value: "#{sessions.size} sessions for #{phase}",
      decision: sessions.map { |s| "#{s[:day]}: #{s[:template_name]} (#{s[:exercises].size} exercises)" }.join("; ")
    )
    result
  end

  private

  def example_phase?(phase)
    EXAMPLE_PHASES.include?(phase)
  end

  # Determine which limiting lift governs this session based on its type.
  # Upper body session types → upper limiting lift, lower body → lower limiting lift.
  def limiting_lift_for_session(session_type, limiting_lift_upper, limiting_lift_lower)
    st = session_type.to_s
    if st.match?(/overhead_press|incline_press|bench_press|dip/) ||
       st.start_with?("upper_body")
      limiting_lift_upper
    else
      limiting_lift_lower
    end
  end

  # ── Example mode (Int1, Acc2) ─────────────────────────────────────────

  def build_example_session(limiting_lift, phase, session_label)
    # Map phase to example lookup key
    example_phase = phase == :accumulation_2 ? :accumulation_2 : :intensification
    lift_key = limiting_lift.to_s.to_sym

    example_sessions = Kilo::OsrExampleSessions.for(@osr_level, lift_key, example_phase)
    return nil unless example_sessions

    # Find the matching session label — if no example exists for this session,
    # fall back to template mode (e.g., Advanced Front Squat Int1 has no LB1 example)
    exercises_data = example_sessions[session_label]
    return nil unless exercises_data

    # Find the A-series primary press rep scheme to substitute for "Max" reps
    a_series_reps = find_a_series_reps(exercises_data)

    exercises_data.map do |ex|
      reps = resolve_reps(ex[:reps], ex[:sets], a_series_reps)

      kilo_exercise = find_exercise(ex[:exercise])

      {
        position: ex[:position],
        category: infer_category(ex[:position]),
        exercise_name: ex[:exercise],
        kilo_exercise_id: kilo_exercise&.id,
        sets: ex[:sets],
        target_reps: reps.to_s,
        tempo: normalize_tempo(ex[:tempo]),
        rest_seconds: ex[:rest],
        group: nil,
        group_type: nil,
        map_adjusted: false
      }
    end
  end

  # ── Template mode (Acc1, Int2) ────────────────────────────────────────

  def build_template_session(limiting_lift, seed_phase, session_label, rep_scheme)
    lift_key = limiting_lift.to_s.to_sym

    # Map seed_phase to template phase key
    template_phase = case seed_phase.to_s
    when "accumulation" then :accumulation
    when "intensification" then :intensification
    when "accumulation_2" then :accumulation_2
    when "intensification_2" then :intensification_2
    else seed_phase.to_sym
    end

    template = Kilo::OsrSessionTemplates.for(lift_key, template_phase, session_label)
    return nil unless template

    a_sets, a_reps = parse_rep_scheme(rep_scheme)
    is_intensification = template_phase.to_s.include?("intensification")

    template.map do |slot|
      use_model_scheme = slot[:position].start_with?("A")
      sets = if use_model_scheme && a_sets
        a_sets
      else
        parse_range(slot[:sets], is_intensification ? :low : :high)
      end

      reps = if use_model_scheme && a_reps
        a_reps.to_s
      else
        parse_range(slot[:reps], is_intensification ? :low : :high).to_s
      end

      kilo_exercise = find_exercise(slot[:exercise])

      {
        position: slot[:position],
        category: infer_category(slot[:position]),
        exercise_name: slot[:exercise],
        kilo_exercise_id: kilo_exercise&.id,
        sets: sets.to_i,
        target_reps: reps,
        tempo: slot[:tempo],
        rest_seconds: slot[:rest],
        group: nil,
        group_type: nil,
        map_adjusted: false
      }
    end
  end

  # ── Helpers ───────────────────────────────────────────────────────────

  def find_exercise(name)
    KiloExercise.find_by(name: name) ||
      KiloExercise.where("name ILIKE ?", name).first ||
      KiloExercise.where("name ILIKE ?", "#{name.split(' - ').first}%").first
  end

  # Normalize macrocycle template session types to valid TrainingSession enum values.
  # Some templates use descriptive names that aren't in the enum.
  VALID_SESSION_TYPES = TrainingSession.session_types.keys.freeze

  def normalize_session_type(session_type)
    st = session_type.to_s
    return st if VALID_SESSION_TYPES.include?(st)

    # Fallback: strip suffixes for any unknown types
    st.gsub(/_variation$/, "").gsub(/_a$/, "")
  end

  def infer_category(position)
    case position
    when /^A/  then "primary"
    when /^B/  then "assistance"
    when /^C/  then "remedial"
    else "other"
    end
  end

  def parse_rep_scheme(rep_scheme)
    return [nil, nil] unless rep_scheme.present?

    if match = rep_scheme.match(/^(\d+)x(\d+)$/)
      [match[1].to_i, match[2].to_i]
    else
      parts = rep_scheme.split(",").map(&:strip)
      [parts.size, rep_scheme]
    end
  end

  def parse_range(range, mode = :low)
    str = range.to_s
    return str.to_i unless str.include?("-")

    parts = str.split("-").map(&:to_i)
    mode == :high ? parts.last : parts.first
  end

  # Day mapping for upper/lower split
  def upper_day(index, frequency)
    case frequency
    when 4 then index == 0 ? "mon" : "thu"
    when 3 then index == 0 ? "mon" : "fri"
    else index == 0 ? "mon" : "thu"
    end
  end

  def lower_day(index, frequency)
    case frequency
    when 4 then index == 0 ? "tue" : "fri"
    when 3 then index == 0 ? "wed" : "fri"
    else index == 0 ? "tue" : "fri"
    end
  end

  # Normalize compact tempo notation to dashed format for display.
  # The rendering code splits on "-" and each input has maxlength=1.
  #
  #   "40X0"  → "4-0-X-0"   (standard 4-char)
  #   "3010"  → "3-0-1-0"
  #   "120X0" → "12-0-X-0"  (5-char with multi-digit eccentric)
  #   "150X0" → "15-0-X-0"
  #   "101X0" → "10-1-X-0"
  #   "10000" → "10-0-0-0"
  #   "4-0-X-0" → "4-0-X-0" (already dashed, pass through)
  #   "40-60" → "4-0-6-0"   (slash notation from examples)
  #
  def normalize_tempo(tempo)
    return "4-0-X-0" if tempo.blank?
    return tempo if tempo.count("-") >= 3 # already dashed

    t = tempo.to_s.strip

    # Handle slash notation from example images (e.g., "40/60" → "4-0-6-0")
    if t.include?("/")
      parts = t.split("/")
      return normalize_tempo(parts[0]) if parts.size == 1
      # e.g., "40/60" → first pair is ecc+pause, second is con+pause
      first = parts[0].chars
      second = parts[1].chars
      return "#{first[0]}-#{first[1] || '0'}-#{second[0]}-#{second[1] || '0'}"
    end

    # 4-character compact: each char is one position
    if t.length == 4
      return t.chars.join("-")
    end

    # 5-character: first two chars are the eccentric (multi-digit), rest are normal
    if t.length == 5
      return "#{t[0..1]}-#{t[2]}-#{t[3]}-#{t[4]}"
    end

    # 6-character: first two chars eccentric, second two pause/concentric (rare)
    if t.length == 6
      return "#{t[0..1]}-#{t[2]}-#{t[3..4]}-#{t[5]}"
    end

    # Fallback: try to split evenly
    t.chars.join("-")
  end

  # Find the A-series primary press exercise's reps to use as "Max" substitute.
  # The first A1 or A exercise that has numeric reps is the reference.
  def find_a_series_reps(exercises_data)
    a_exercise = exercises_data.find { |ex| ex[:position].start_with?("A") && ex[:reps].to_s != "Max" }
    a_exercise ? a_exercise[:reps].to_s : "8"
  end

  # Resolve special rep notations:
  #   "Max" → substitute with A-series reps
  #   "6+2" → total reps (8) for Con-Ecc combos
  #   "5,5,4,4,4" → pass through (wave loading)
  #   numeric string → pass through
  def resolve_reps(reps, sets, a_series_reps)
    reps_str = reps.to_s.strip
    if reps_str.casecmp("max").zero?
      a_series_reps
    elsif reps_str.include?("+")
      # Con-Ecc combo: "4+2" → 6 total reps
      parts = reps_str.split("+").map(&:to_i)
      parts.sum.to_s
    else
      reps_str
    end
  end
end
