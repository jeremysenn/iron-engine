# Populates target_weight on ExerciseSets based on logged workout history.
#
# After a program is generated, this service looks up each exercise's most
# recent logged performance across all of the client's programs. From that
# logged set it estimates the client's current 1RM, then derives the
# appropriate weight for the prescribed reps.
#
# Loading strategies (A-series only; B/C-series always use constant):
#   Step loading  — A-series, uniform reps, when program's resolved
#                   loading method is "step" (default for intermediate/advanced).
#                   Top set = estimated RM for target reps.
#                   Each prior set drops ~2.5%.
#
#   Constant loading — A-series when program's resolved loading method is
#                      "constant" (default for novice), or variable rep schemes,
#                      or B/C-series.
#                      Every set uses the estimated RM for that set's
#                      target reps.
#
# Fallback order:
#   1. Most recent logged ExerciseSet (actual_weight + actual_reps)
#   2. PrimeEight Assessment E1RM (for the 8 core lifts)
#   3. No suggestion (target_weight stays 0)
#
# All weights are rounded to the nearest 5 (barbell plate increment).
#
class Kilo::LoadingSchemeCalculator
  # Maps exercise name patterns to PrimeEight exercise enum values.
  # Squat/Deadlift use exact match to avoid false positives like
  # "Squat - Hack - BB" or "Deadlift - Romanian - BB".
  # Others use prefix match since their variations (grip, stance) are
  # still the same fundamental movement.
  PRIME_EIGHT_PATTERNS = [
    [/\ASquat\z/, :squat],
    [/\AFront Squat/, :front_squat],
    [/\ADeadlift\z/, :deadlift],
    [/\ABench Press/, :bench_press],
    [/\AOverhead Press/, :overhead_press],
    [/\AIncline Press/, :incline_press],
    [/\ADip/, :dip],
    [/\AChin-Up/, :chin_up]
  ].freeze

  # Populates target weights for an entire program (called at generation time).
  def call(program)
    @client = program.client
    @training_level = program.training_level
    @a_series_loading_method = program.a_series_loading_method_resolved
    @prime_eight_e1rms = load_prime_eight_e1rms

    program.macrocycles.includes(
      mesocycles: { microcycles: { training_sessions: { session_exercises: :exercise_sets } } }
    ).each do |macrocycle|
      macrocycle.mesocycles.each do |mesocycle|
        mesocycle.microcycles.each do |microcycle|
          microcycle.training_sessions.each do |session|
            session.session_exercises.each do |session_exercise|
              populate_weights(session_exercise)
            end
          end
        end
      end
    end
  end

  # Recalculates target weights for future sessions after a workout is logged.
  #
  # For A-series exercises, applies progressive overload: each set's logged
  # weight is bumped up ~2.5% (rounded to nearest 5). This uses the actual
  # per-set weights from the logged session rather than recalculating from E1RM.
  #
  # For B/C-series exercises, recalculates from E1RM as usual.
  #
  def recalculate_after_logging(training_session)
    program = training_session.microcycle.mesocycle.macrocycle.program
    @client = program.client
    @training_level = program.training_level
    @a_series_loading_method = program.a_series_loading_method_resolved
    @prime_eight_e1rms = load_prime_eight_e1rms

    # Build a lookup of logged exercises: { exercise_key => session_exercise }
    logged_exercises = training_session.session_exercises.includes(:exercise_sets).select do |se|
      se.exercise_sets.any? { |es| es.actual_weight.to_f > 0 && es.actual_reps.to_i > 0 }
    end
    return if logged_exercises.empty?

    logged_by_key = {}
    logged_exercises.each do |se|
      key = se.kilo_exercise_id || se.exercise_name
      logged_by_key[key] = se
    end

    # Find all future session_exercises in this program that match
    logged_session_week = training_session.microcycle.week_number
    logged_session_day = training_session.day

    program.macrocycles.includes(
      mesocycles: { microcycles: { training_sessions: { session_exercises: :exercise_sets } } }
    ).each do |macrocycle|
      macrocycle.mesocycles.each do |mesocycle|
        mesocycle.microcycles.each do |microcycle|
          microcycle.training_sessions.each do |session|
            # Skip sessions at or before the logged session
            next if microcycle.week_number < logged_session_week
            next if microcycle.week_number == logged_session_week && session.day <= logged_session_day

            session.session_exercises.each do |se|
              key = se.kilo_exercise_id || se.exercise_name
              logged_se = logged_by_key[se.kilo_exercise_id] || logged_by_key[se.exercise_name]
              next unless logged_se

              if se.position.start_with?("A")
                apply_progressive_overload(se, logged_se)
              else
                populate_weights(se)
              end
            end
          end
        end
      end
    end
  end

  private

  def populate_weights(session_exercise)
    e1rm = estimate_e1rm(session_exercise)
    return unless e1rm

    exercise_sets = session_exercise.exercise_sets.order(:set_number).to_a
    return if exercise_sets.empty?

    is_a_series = session_exercise.position.start_with?("A")
    uniform_reps = exercise_sets.map(&:target_reps).uniq.size == 1
    use_step_loading = is_a_series && uniform_reps && @a_series_loading_method == "step"

    if use_step_loading
      apply_step_loading(exercise_sets, e1rm)
    else
      apply_constant_loading(exercise_sets, e1rm)
    end
  end

  # Returns the client's estimated 1RM for this exercise, or nil.
  def estimate_e1rm(session_exercise)
    # Priority 1: logged workout history
    logged_set = find_most_recent_logged_set(session_exercise)
    if logged_set
      return calculate_e1rm(logged_set.actual_weight.to_f, logged_set.actual_reps.to_i)
    end

    # Priority 2: PrimeEight Assessment
    prime_eight_exercise = match_prime_eight(session_exercise.exercise_name)
    @prime_eight_e1rms[prime_eight_exercise] if prime_eight_exercise
  end

  # Finds the heaviest logged set from the most recent session containing
  # this exercise, across all of the client's programs.
  def find_most_recent_logged_set(session_exercise)
    scope = ExerciseSet
      .joins(session_exercise: { training_session: { microcycle: { mesocycle: { macrocycle: :program } } } })
      .where(programs: { client_id: @client.id })
      .where.not(actual_weight: nil)
      .where.not(actual_reps: nil)
      .where("exercise_sets.actual_weight > 0")
      .where("exercise_sets.actual_reps > 0")

    if session_exercise.kilo_exercise_id
      scope = scope.where(session_exercises: { kilo_exercise_id: session_exercise.kilo_exercise_id })
    else
      scope = scope.where(session_exercises: { exercise_name: session_exercise.exercise_name })
    end

    # Most recent by workout date (completed_at), falling back to created_at
    scope.order(
      Arel.sql("COALESCE(training_sessions.completed_at, training_sessions.created_at::date) DESC"),
      "exercise_sets.actual_weight DESC"
    ).first
  end

  # Matches an exercise name to a PrimeEight exercise enum value.
  def match_prime_eight(exercise_name)
    PRIME_EIGHT_PATTERNS.each do |pattern, enum_val|
      return enum_val if exercise_name.match?(pattern)
    end
    nil
  end

  # Loads the most recent PrimeEight Assessment E1RMs for this client.
  def load_prime_eight_e1rms
    assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first
    return {} unless assessment

    assessment.prime_eight_lifts.each_with_object({}) do |lift, hash|
      hash[lift.exercise.to_sym] = lift.e1rm.to_f
    end
  end

  # Calculates E1RM from a single performance (weight x reps).
  def calculate_e1rm(weight, reps)
    return nil if weight <= 0 || reps <= 0

    if reps == 1
      weight.to_f
    elsif reps <= 20
      intensity = KiloRepIntensityTable.lookup(reps)
      if intensity
        (weight / (intensity / 100.0)).round(1)
      else
        epley(weight, reps)
      end
    else
      epley(weight, reps)
    end
  end

  def epley(weight, reps)
    (weight * (1 + 0.0333 * reps)).round(1)
  end

  # Derives the estimated weight for a given rep count from the E1RM.
  def weight_for_reps(e1rm, target_reps)
    return e1rm if target_reps == 1

    if target_reps <= 20
      intensity = KiloRepIntensityTable.lookup(target_reps)
      return (e1rm * intensity / 100.0) if intensity
    end

    # Epley inverse: weight = e1rm / (1 + 0.0333 * reps)
    e1rm / (1 + 0.0333 * target_reps)
  end

  # Progressive overload for A-series: bumps each logged set's weight up ~2.5%.
  # Uses per-set actual weights from the previous session rather than E1RM.
  #
  # Step loading (Intermediate/Advanced, uniform reps):
  #   Logged: 100, 105, 110, 115 → Future: 105, 110, 115, 120
  #
  # Constant loading (Novice, or variable reps):
  #   Logged: 105, 105, 105, 105 → Future: 110, 110, 110, 110
  #
  def apply_progressive_overload(future_se, logged_se)
    future_sets = future_se.exercise_sets.order(:set_number).to_a
    logged_sets = logged_se.exercise_sets.order(:set_number)
      .where("actual_weight > 0").to_a
    return if future_sets.empty? || logged_sets.empty?

    future_sets.each_with_index do |set, i|
      # Use the corresponding logged set, or the last one if fewer sets
      source_set = logged_sets[i] || logged_sets.last
      bumped = source_set.actual_weight.to_f * 1.025
      set.update!(target_weight: round_up_to_nearest_5(bumped))
    end
  end

  # Step loading: top set = RM, each prior set drops 2.5%.
  def apply_step_loading(exercise_sets, e1rm)
    target_reps = exercise_sets.first.target_reps
    rm_weight = weight_for_reps(e1rm, target_reps)
    num_sets = exercise_sets.size

    exercise_sets.each_with_index do |set, i|
      steps_below_top = num_sets - (i + 1)
      raw_weight = rm_weight * (1 - 0.025 * steps_below_top)
      set.update!(target_weight: round_to_nearest_5(raw_weight))
    end
  end

  # Constant loading: each set uses the RM for that set's target reps.
  def apply_constant_loading(exercise_sets, e1rm)
    exercise_sets.each do |set|
      rm_weight = weight_for_reps(e1rm, set.target_reps)
      set.update!(target_weight: round_to_nearest_5(rm_weight))
    end
  end

  def round_to_nearest_5(value)
    (value / 5.0).round * 5
  end

  # Always rounds up for progressive overload so weights never stay flat.
  def round_up_to_nearest_5(value)
    (value / 5.0).ceil * 5
  end
end
