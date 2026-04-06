# Generates training sessions from KILO session templates.
#
# Each session type (overhead_press, squat_1, etc.) has a fixed template
# from the Program Design Resource that defines exercise slots with
# default exercises, set/rep ranges, tempos, and rest periods.
#
# The A-series rep scheme is overridden by the periodization model.
# B and C series use the template's fixed ranges.
#
# Coaches can override any exercise in any slot. The defaults follow
# the 90-degree principle and grip selection rules automatically.
#
# MAP Assessment integration: when a movement result is provided,
# exercise progressions are substituted for clients who can't perform
# the standard movement at the required level.
#
class Kilo::SessionGenerator
  class SessionBlueprint < Kilo::Result
    attr_reader :sessions
  end

  # Generates session blueprints for one microcycle (1 week)
  #
  # @param microcycle_structure [Hash] the selected structure from MicrocycleStructures
  # @param split_structure [Hash] day -> session_type mapping (from training split)
  # @param rep_scheme [String] A-series rep scheme from periodization model
  # @param intensity_pct [Decimal] A-series intensity from periodization model
  # @param exercise_overrides [Hash] position-keyed overrides from coach (optional)
  # @param movement_result [MovementResult] MAP assessment result (optional)
  def call(split_structure:, rep_scheme: nil, intensity_pct: nil,
           microcycle_structure: nil, exercise_overrides: {},
           movement_result: nil, methods: [], **_ignored)

    sessions = []

    split_structure.each do |day, session_type|
      # Resolve session type: if it's a generic type like "upper_body_1",
      # use the microcycle structure to get the specific template
      resolved_type = resolve_session_type(session_type.to_s, microcycle_structure)
      template = Kilo::SessionTemplates.for(resolved_type)

      # Fall back to a generic session if no template found
      unless template
        sessions << { day: day.to_s, session_type: session_type.to_s, template_name: session_type.to_s.titleize, exercises: [] }
        next
      end

      exercises = build_from_template(
        template: template,
        rep_scheme: rep_scheme,
        intensity_pct: intensity_pct,
        overrides: exercise_overrides.dig(day.to_s) || {},
        movement_result: movement_result
      )

      sessions << {
        day: day.to_s,
        session_type: resolved_type,
        template_name: template[:name],
        exercises: exercises
      }
    end

    result = SessionBlueprint.new(sessions: sessions)

    result.annotate(
      step: "session_generation",
      rule: "Template-based session generation",
      value: "#{sessions.size} sessions from KILO templates",
      decision: sessions.map { |s| "#{s[:day]}: #{s[:template_name]} (#{s[:exercises].size} exercises)" }.join("; ")
    )

    result
  end

  private

  # Resolves generic session types (upper_body_1) to specific templates
  # (overhead_press) using the microcycle structure
  def resolve_session_type(session_type, microcycle_structure)
    return session_type if Kilo::SessionTemplates.for(session_type)
    return session_type unless microcycle_structure

    microcycle_structure[session_type.to_sym] || microcycle_structure[session_type.to_s] || session_type
  end

  def build_from_template(template:, rep_scheme:, intensity_pct:, overrides:, movement_result:)
    a_sets, a_reps = parse_rep_scheme(rep_scheme)

    template[:slots].map do |slot|
      exercise_name = overrides[slot[:position]] || slot[:default_exercise]

      # Apply MAP progression if available
      if movement_result&.complete? && slot[:category]&.start_with?("primary_")
        progression = map_progression_for(slot[:category], movement_result)
        exercise_name = progression if progression
      end

      # A-series uses periodization model rep scheme, B/C use template defaults
      is_a_series = slot[:position].start_with?("A")
      sets = is_a_series && a_sets ? a_sets : parse_set_range(slot[:sets])
      reps = is_a_series && a_reps ? a_reps : slot[:reps]

      # Find the exercise in the database (or use the name as-is)
      kilo_exercise = KiloExercise.find_by("name ILIKE ?", "%#{exercise_name.split('(').first.strip}%")

      {
        position: slot[:position],
        category: slot[:category],
        exercise_name: exercise_name,
        kilo_exercise_id: kilo_exercise&.id,
        sets: sets,
        target_reps: reps.to_s,
        tempo: slot[:tempo],
        rest_seconds: slot[:rest]
      }
    end
  end

  # Checks MAP results for movement restrictions and returns appropriate
  # exercise progression. Returns nil if no MAP override needed.
  def map_progression_for(category, movement_result)
    return nil unless movement_result&.levels

    case category
    when "primary_squat"
      squat_data = movement_result.levels["squat"]
      if squat_data && squat_data[:level].to_i < 3
        "Goblet Squat" # MAP progression for failed squat levels
      end
    when "primary_front_squat"
      squat_data = movement_result.levels["squat"]
      if squat_data && squat_data[:level].to_i < 2
        "Goblet Squat"
      end
    when "primary_deadlift"
      dl_data = movement_result.levels["deadlift"]
      if dl_data && dl_data[:level].to_i < 2
        "Romanian Deadlift"
      end
    end
  end

  def parse_rep_scheme(rep_scheme)
    return [nil, nil] unless rep_scheme.present?

    if match = rep_scheme.match(/^(\d+)x(\d+)$/)
      [match[1].to_i, match[2].to_i]
    else
      # Complex rep scheme like "12,10,8,6" - use the count as sets
      parts = rep_scheme.split(",").map(&:strip)
      [parts.size, rep_scheme]
    end
  end

  def parse_set_range(range)
    # "3-4" -> use the lower end as default
    range.to_s.split("-").first.to_i
  end
end
