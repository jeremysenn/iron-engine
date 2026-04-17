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
           movement_result: nil, methods: [], phase: :accumulation, **_ignored)
    sessions = []

    split_structure.each do |day, session_type|
      # Resolve session type: if it's a generic type like "upper_body_1",
      # use the microcycle structure to get the specific template
      resolved_type = resolve_session_type(session_type.to_s, microcycle_structure)
      template = Kilo::SessionTemplates.for(resolved_type, phase: phase)

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
        movement_result: movement_result,
        phase: phase
      )

      estimated_duration = Kilo::RestCalculator.estimate_duration(exercises)

      sessions << {
        day: day.to_s,
        session_type: resolved_type,
        template_name: template[:name],
        exercises: exercises,
        estimated_duration: estimated_duration
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

  def build_from_template(template:, rep_scheme:, intensity_pct:, overrides:, movement_result:, phase: :accumulation)
    a_sets, a_reps = parse_rep_scheme(rep_scheme)

    template[:slots].map do |slot|
      exercise_name = overrides[slot[:position]] || slot[:default_exercise]

      # Apply MAP progression if available (per-pattern — doesn't require full assessment)
      map_adjusted = false
      if movement_result
        progression = map_progression_for(slot[:category], slot[:default_exercise], movement_result)
        if progression
          exercise_name = progression
          map_adjusted = true
        end
      end

      # A-series (and primary slots in full body) use periodization model rep scheme
      use_model_scheme = slot[:position].start_with?("A") || slot[:primary]
      sets = use_model_scheme && a_sets ? a_sets : parse_range(slot[:sets], :low)
      reps = use_model_scheme && a_reps ? a_reps : parse_range(slot[:reps], phase)

      # Find the exercise in the database: try exact match, then partial
      kilo_exercise = KiloExercise.find_by(name: exercise_name) ||
                      KiloExercise.where("name ILIKE ?", exercise_name).first ||
                      KiloExercise.where("name ILIKE ?", "#{exercise_name.split(' - ').first}%").first

      {
        position: slot[:position],
        category: slot[:category],
        exercise_name: exercise_name,
        kilo_exercise_id: kilo_exercise&.id,
        sets: sets,
        target_reps: reps.to_s,
        tempo: slot[:tempo],
        rest_seconds: Kilo::RestCalculator.for(slot[:position], phase: phase, template_rest: slot[:rest]),
        group: slot[:group],
        group_type: slot[:group_type],
        map_adjusted: map_adjusted
      }
    end
  end

  # Checks MAP results for movement restrictions and returns the appropriate
  # Progression 1 exercise from the MAP Assessment Resource.
  #
  # Each movement pattern's tested level + pass/fail status maps to a specific
  # progression table. This method returns Progression 1 (the starting exercise)
  # from the appropriate table.
  #
  # Returns nil if no MAP override is needed (client can perform the default).
  #
  def map_progression_for(category, default_exercise, movement_result)
    return nil unless movement_result&.levels

    case category
    when "primary_squat"       then map_squat_progression(movement_result)
    when "primary_front_squat" then map_front_squat_progression(movement_result)
    when "primary_deadlift"    then map_deadlift_progression(movement_result)
    when "split_stance"        then map_split_stance_progression(default_exercise, movement_result)
    when "knee_extension"      then map_knee_extension_progression(default_exercise, movement_result)
    when "hip_extension"       then map_seated_goodmorning_progression(movement_result)
    when "primary_pull"        then map_pull_progression(default_exercise, movement_result)
    when "primary_press"       then map_press_progression(default_exercise, movement_result)
    when "assistance_pull"     then map_row_progression(default_exercise, movement_result)
    when "assistance_press"    then map_push_up_progression(default_exercise, movement_result)
    when "external_rotation"   then map_external_rotation_progression(movement_result)
    when "scapular_retraction" then map_scapular_retraction_progression(default_exercise, movement_result)
    when "shoulders"           then map_scapular_retraction_progression(default_exercise, movement_result)
    end
  end

  # ── Lower Body MAP Progressions ──────────────────────────────────────

  # MAP Assessment Resource — Squat Progressions (p.5)
  #
  #   Pass Level 4 → Prog 1: Squat - Goblet - 30° Heel Elevation
  #   Fail Level 4 → Squat - To Box - Top Range - BB
  #   Pass Level 3 → Prog 1: Squat - Goblet - 10° Heel Elevation
  #
  def map_squat_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "squat")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 4, true ]  then "Squat - Goblet - 30° Heel Elevation"
    when [ 4, false ] then "Squat - To Box - Top Range - BB"
    when [ 3, true ]  then "Squat - Goblet - 10° Heel Elevation"
    end
  end

  # Front squat uses squat MAP data. Appears as Prog 3 in the squat ladder.
  # No explicit front squat progression table in the resource — only override
  # when the squat progression table itself covers it.
  #   Pass Level 3+ → nil (Front Squat is safe)
  #   Otherwise → nil (no explicit progression defined)
  def map_front_squat_progression(movement_result)
    nil
  end

  # MAP Assessment Resource — Deadlift Progressions (p.6)
  #
  #   Fail Level 1 → Prog 1: Rack Deadlift - Mid Thigh - Medium Grip
  #   Fail Level 2 → Prog 1: Deadlift - Rack - Below Knee - Wide Grip
  #   Fail Level 3 → Prog 1: Romanian Deadlift
  #   Any pass     → nil (use default)
  #
  def map_deadlift_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "deadlift")
    return nil unless tested_level
    return nil if passed

    case tested_level
    when 1 then "Rack Deadlift - Mid Thigh - Medium Grip"
    when 2 then "Deadlift - Rack - Below Knee - Wide Grip"
    when 3 then "Romanian Deadlift"
    end
  end

  # Routes split_stance category to the correct MAP pattern based on exercise name.
  def map_split_stance_progression(default_exercise, movement_result)
    if default_exercise =~ /Step-Up/i
      map_step_up_progression(movement_result)
    else
      map_split_squat_progression(movement_result)
    end
  end

  # Routes knee_extension category to Step-Up MAP when the exercise is a step-up.
  def map_knee_extension_progression(default_exercise, movement_result)
    if default_exercise =~ /Step-Up/i
      map_step_up_progression(movement_result)
    end
  end

  # MAP Assessment Resource — Split Squat Progressions (p.7)
  #
  #   Pass Level 3 → Prog 1: Split Squat - Front Foot Elevated 12" - Low Pulley
  #   Fail Level 3 → Prog 1: Backward Sled Drag
  #   Pass Level 2 → Prog 1: Split Squat - Front Foot Elevated 6" - Low Pulley
  #
  def map_split_squat_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "split_squat")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 3, true ]  then "Split Squat - Front Foot Elevated 12\" - Low Pulley"
    when [ 3, false ] then "Backward Sled Drag"
    when [ 2, true ]  then "Split Squat - Front Foot Elevated 6\" - Low Pulley"
    end
  end

  # MAP Assessment Resource — Step-Up Progressions (p.9)
  #
  #   Pass Level 1 → Step-Up - 40° Heel Elevation
  #   Pass Level 2 → Step-Up - Front
  #   Pass Level 3 → Step-Up - Side
  #   Fail Level 3 → Prog 1: Backward Sled Drag
  #
  def map_step_up_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "step_up")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 3, true ]  then "Step-Up - Side"
    when [ 3, false ] then "Backward Sled Drag"
    when [ 2, true ]  then "Step-Up - Front"
    when [ 1, true ]  then "Step-Up - 40° Heel Elevation"
    end
  end

  # MAP Assessment Resource — Seated Goodmorning Progressions (p.8)
  # Applies to hip_extension category exercises.
  #
  #   Pass Level 3 → tempo override only (6-0-1-0) — no exercise change
  #   Fail Level 3 → Prog 1: Back Extension - Incline - 40°
  #
  def map_seated_goodmorning_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "seated_goodmorning")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 3, false ] then "Back Extension - Incline - 40°"
    end
  end

  # ── Upper Body MAP Progressions ──────────────────────────────────────

  # MAP Assessment Resource — Chin-Up Progressions (p.11)
  #
  #   Fail → Prog 1: Pulldown - Lean 45° - Medium Grip - Neutral
  #   Pass → nil (use default)
  #
  def map_pull_progression(default_exercise, movement_result)
    return nil unless default_exercise =~ /Chin-Up|Pull-Up/i

    tested_level, passed = map_tested_level(movement_result, "chin_up")
    return nil unless tested_level
    return nil if passed

    "Pulldown - Lean 45° - Medium Grip - Neutral"
  end

  # MAP Assessment Resource — Dip (p.11) & Overhead Press (p.12)
  #
  # Dip:
  #   Fail ROM      → Prog 1: Press - 25° Decline - DB - Rotating Grip
  #   Fail Scapular → Prog 1: Push-Up - Rings
  #   (Form cannot distinguish — defaults to Fail ROM regression)
  #   Pass → nil
  #
  # Overhead Press:
  #   Pass Level 3 → Prog 1: Press - Seated - Arnold - DB
  #   Fail Level 3 → Prog 1: Press - High Incline - DB
  #   Pass Level 2 → Prog 1: Press - Seated - Unsupported - DB
  #   Fail Level 2 or below → Press - High Incline - DB
  #
  def map_press_progression(default_exercise, movement_result)
    if default_exercise =~ /Dip/i
      map_dip_progression(movement_result)
    elsif default_exercise =~ /Overhead Press/i || default_exercise =~ /^Press - Seated - BB/i
      map_overhead_press_progression(movement_result)
    end
  end

  # Dip fail type is stored in exercise_name field:
  #   "rom"      → Fail ROM → Prog 1: Press - 25° Decline - DB - Rotating Grip
  #   "scapular" → Fail Scapular → Prog 1: Push-Up - Rings
  #   nil        → default to Fail ROM regression
  def map_dip_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "dip")
    return nil unless tested_level
    return nil if passed

    fail_type = movement_result.levels["dip"]&.dig(:exercise)
    case fail_type
    when "scapular" then "Push-Up - Rings"
    else "Press - 25° Decline - DB - Rotating Grip"
    end
  end

  def map_overhead_press_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "overhead_press")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 3, true ]  then "Press - Seated - Arnold - DB"
    when [ 3, false ] then "Press - High Incline - DB"
    when [ 2, true ]  then "Press - Seated - Unsupported - DB"
    end
  end

  # MAP Assessment Resource — Row Progressions (p.13)
  # Applies to assistance_pull category when exercise is a Row.
  #
  #   Pass Level 3 → Prog 1: Pulldown - Lean 45° - Close Grip - Semi-Supinated
  #   Fail Level 3 → Prog 1 A-Series: Scapula Retraction - Facing - High Pulley - One-Arm
  #   Pass Level 2 → Prog 1: Pulldown - Lean 45° - Medium Grip - Neutral
  #
  def map_row_progression(default_exercise, movement_result)
    return nil unless default_exercise =~ /Row/i

    tested_level, passed = map_tested_level(movement_result, "row")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 3, true ]  then "Pulldown - Lean 45° - Close Grip - Semi-Supinated"
    when [ 3, false ] then "Scapula Retraction - Facing - High Pulley - One-Arm"
    when [ 2, true ]  then "Pulldown - Lean 45° - Medium Grip - Neutral"
    end
  end

  # MAP Assessment Resource — Push-Up Progressions (p.14)
  # Applies to assistance_press category when exercise is push-up related.
  #
  #   Pass Level 3 → Prog 1: Push-Up - Incline
  #   Fail Level 3 → Decline Press DB Variations
  #   Pass Level 2 → Prog 1: Push-Up - Kneeling
  #
  def map_push_up_progression(default_exercise, movement_result)
    return nil unless default_exercise =~ /Push-Up/i

    tested_level, passed = map_tested_level(movement_result, "push_up")
    return nil unless tested_level

    case [ tested_level, passed ]
    when [ 3, true ]  then "Push-Up - Incline"
    when [ 3, false ] then "Press - 25° Decline - DB"
    when [ 2, true ]  then "Push-Up - Kneeling"
    end
  end

  # MAP Assessment Resource — External Rotation Progressions (p.15)
  # Fail type stored in exercise_name field:
  #   "external_rom" → Prog 1: External Rotation - Side Lying - DB - One-Arm
  #   "internal_rom" → Prog 1: External Rotation - Side Lying - DB - One-Arm
  #   "both_rom"     → Prog 1: External Rotation - Sideway - Mid Pulley - Neutral - One-Arm
  #   Pass → nil
  #
  def map_external_rotation_progression(movement_result)
    tested_level, passed = map_tested_level(movement_result, "external_rotation")
    return nil unless tested_level
    return nil if passed

    fail_type = movement_result.levels["external_rotation"]&.dig(:exercise)
    case fail_type
    when "both_rom" then "External Rotation - Sideway - Mid Pulley - Neutral - One-Arm"
    else "External Rotation - Side Lying - DB - One-Arm"
    end
  end

  # MAP Assessment Resource — Trap 3 Raise (p.16) & Prone Lateral Raise (p.16)
  # Applies to scapular_retraction and shoulders categories.
  #
  #   Trap 3 exercises → check trap_3_raise MAP
  #     Fail → Prog 1: Trap 3 - Prone - 45° Incline - DB - One-Arm
  #   Lateral Raise / Powell Raise exercises → check prone_lateral_raise MAP
  #     Fail → Prog 1: Lateral Raise - Prone - 45° Incline - DB - Neutral - One-Arm
  #   Pass → nil
  #
  def map_scapular_retraction_progression(default_exercise, movement_result)
    if default_exercise =~ /Trap 3/i
      tested_level, passed = map_tested_level(movement_result, "trap_3_raise")
      return nil unless tested_level
      return nil if passed
      "Trap 3 - Prone - 45° Incline - DB - One-Arm"
    elsif default_exercise =~ /Lateral Raise|Powell Raise/i
      tested_level, passed = map_tested_level(movement_result, "prone_lateral_raise")
      return nil unless tested_level
      return nil if passed
      "Lateral Raise - Prone - 45° Incline - DB - Neutral - One-Arm"
    end
  end

  # ── Helpers ──────────────────────────────────────────────────────────

  # Extracts the tested level and pass/fail for a MAP movement pattern.
  # Returns [tested_level, passed] or [nil, nil] if no data.
  def map_tested_level(movement_result, pattern)
    data = movement_result.levels[pattern]
    return [ nil, nil ] unless data&.dig(:all_entries)&.any?

    entry = data[:all_entries].max_by { |e| e[:level] }
    [ entry[:level], entry[:passed] ]
  end

  def parse_rep_scheme(rep_scheme)
    return [ nil, nil ] unless rep_scheme.present?

    if match = rep_scheme.match(/^(\d+)x(\d+)$/)
      [ match[1].to_i, match[2].to_i ]
    else
      # Complex rep scheme like "12,10,8,6" - use the count as sets
      parts = rep_scheme.split(",").map(&:strip)
      [ parts.size, rep_scheme ]
    end
  end

  # Parses a range string, picking high or low end based on mode.
  #   :accumulation / :high → high end: "6-10" → 10
  #   :intensification / :low → low end: "6-10" → 6
  #   Non-range values pass through: "3" → 3
  def parse_range(range, mode = :low)
    str = range.to_s
    return str unless str.include?("-")

    parts = str.split("-").map(&:to_i)
    mode.to_sym.in?(%i[accumulation high]) ? parts.last : parts.first
  end
end
