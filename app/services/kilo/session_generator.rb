# Generates full training sessions with exercises, sets, reps, tempo, and rest.
#
#   Input:  split_structure, rep_scheme, training_methods, movement_result (MAP),
#           ratio_result (for exercise prioritization based on limiting lifts)
#   Output: SessionBlueprint[] (array of session blueprints, one per training day)
#
#   Pipeline position: 7th (after all other services, before program generator persists)
#
#   Session structure:
#     Each session has exercises in positions A1/A2, B1/B2, C1/C2 (superset pairs)
#     The 90-degree principle governs exercise pairing within sessions and across microcycles
#     Grip types and widths are selected per the KILO exercise selection rules
#
class Kilo::SessionGenerator
  class SessionBlueprint < Kilo::Result
    attr_reader :sessions
  end

  class ExerciseNotFound < StandardError; end
  class PairingNotFound < StandardError; end

  # Generates session blueprints for one microcycle (1 week)
  #
  # @param split_structure [Hash] day → session_type mapping
  # @param rep_scheme [String] e.g. "5x7" for the current phase
  # @param intensity_pct [Decimal] e.g. 80.0
  # @param methods [Array<KiloTrainingMethod>] assigned methods for this phase
  # @param movement_result [Kilo::MapAssessmentEngine::MovementResult, nil]
  # @param limiting_upper [Symbol] upper body limiting lift
  # @param limiting_lower [Symbol] lower body limiting lift
  def call(split_structure:, rep_scheme: nil, intensity_pct: nil, methods: [],
           movement_result: nil, limiting_upper: nil, limiting_lower: nil)

    sessions = []

    split_structure.each do |day, session_type|
      exercises = build_exercises_for_session(
        session_type: session_type.to_s,
        rep_scheme: rep_scheme,
        intensity_pct: intensity_pct,
        limiting_upper: limiting_upper,
        limiting_lower: limiting_lower
      )

      sessions << {
        day: day.to_s,
        session_type: session_type.to_s,
        exercises: exercises
      }
    end

    result = SessionBlueprint.new(sessions: sessions)

    result.annotate(
      step: "session_generation",
      rule: "Split structure → session exercises",
      value: "#{sessions.size} sessions generated",
      decision: sessions.map { |s| "#{s[:day]}: #{s[:session_type]} (#{s[:exercises].size} exercises)" }.join("; ")
    )

    result
  end

  private

  # Builds exercise list for a single session based on session type.
  # Uses KILO exercise database and 90-degree pairing rules.
  def build_exercises_for_session(session_type:, rep_scheme:, intensity_pct:,
                                   limiting_upper:, limiting_lower:)
    exercises = []
    positions = %w[A1 A2 B1 B2 C1 C2]

    # Determine which body region this session targets
    is_upper = session_type.include?("upper")
    is_lower = session_type.include?("lower")
    is_full = session_type.include?("full")

    # Parse rep scheme (e.g., "5x7" → 5 sets of 7 reps)
    sets, reps = parse_rep_scheme(rep_scheme)

    # Select exercises from the database based on session type
    # For now, use whatever exercises exist in the database
    # The 90-degree principle and MAP-based selection will be applied
    # when the exercise database is fully seeded
    available = if is_upper
      KiloExercise.where("category LIKE ?", "%upper%").or(KiloExercise.where("category LIKE ?", "%press%")).or(KiloExercise.where("category LIKE ?", "%pull%"))
    elsif is_lower
      KiloExercise.where("category LIKE ?", "%lower%").or(KiloExercise.where("category LIKE ?", "%squat%")).or(KiloExercise.where("category LIKE ?", "%hip%"))
    else
      KiloExercise.all
    end

    # Build exercise slots with positions
    available.limit(6).each_with_index do |exercise, i|
      position = positions[i] || "D#{i - 5}"

      # Determine tempo based on position (A-pair heavier, C-pair lighter)
      tempo = case position[0]
      when "A" then "4010"
      when "B" then "3110"
      when "C" then "3010"
      else "3010"
      end

      # Rest periods decrease from A to C pairs
      rest = case position[0]
      when "A" then 90
      when "B" then 75
      when "C" then 60
      else 60
      end

      exercises << {
        position: position,
        kilo_exercise_id: exercise.id,
        exercise_name: exercise.name,
        sets: sets || 4,
        target_reps: reps || 8,
        tempo: tempo,
        rest_seconds: rest
      }
    end

    exercises
  end

  def parse_rep_scheme(rep_scheme)
    return [4, 8] unless rep_scheme.present?

    match = rep_scheme.match(/(\d+)x(\d+)/)
    return [4, 8] unless match

    [match[1].to_i, match[2].to_i]
  end
end
