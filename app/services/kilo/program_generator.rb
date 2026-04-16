# Orchestrator: ties all KILO engine services together to generate a complete program.
#
#   Input:  client, goal, volume, frequency (+ optional MAP assessment)
#   Output: Program (persisted) with full hierarchy down to ExerciseSets
#
#   Pipeline:
#   ┌────────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
#   │ MapAssessment  │──▶│ StrengthRatio│──▶│ Periodization│──▶│ Macrocycle   │
#   │ Engine         │   │ Calculator   │   │ Engine       │   │ Builder      │
#   └────────────────┘   └──────────────┘   └──────────────┘   └──────┬───────┘
#                                                                      │
#   ┌────────────────┐   ┌──────────────┐   ┌──────────────┐          │
#   │ Session        │◀──│ Training     │◀──│ Training     │◀─────────┘
#   │ Generator      │   │ Method Timer │   │ Split Select │
#   └───────┬────────┘   └──────────────┘   └──────────────┘
#           │
#           ▼
#   ┌────────────────┐
#   │ persist!       │  Wraps in transaction, creates all records
#   └────────────────┘
#
class Kilo::ProgramGenerator
  class SeedDataMissing < StandardError; end

  def initialize
    @map_engine = Kilo::MapAssessmentEngine.new
    @ratio_calculator = Kilo::StrengthRatioCalculator.new
    @periodization_engine = Kilo::PeriodizationEngine.new
    @macrocycle_builder = Kilo::MacrocycleBuilder.new
    @split_selector = Kilo::TrainingSplitSelector.new
    @method_timer = Kilo::TrainingMethodTimer.new
    @session_generator = Kilo::SessionGenerator.new
    @loading_calculator = Kilo::LoadingSchemeCalculator.new
  end

  # @param client [Client]
  # @param assessment [PrimeEightAssessment]
  # @param goal [String] hypertrophy/absolute_strength/relative_strength/power
  # @param volume [String] low/medium/high
  # @param frequency [Integer] 2/3/4/5
  # @param acc_structure [Hash] per-slot session types for accumulation phases
  # @param int_structure [Hash] per-slot session types for intensification phases
  # @param map_assessment [MapAssessment, nil] optional MAP for exercise personalization
  def call(client:, assessment:, goal:, volume:, frequency:,
           acc_structure: nil, int_structure: nil,
           acc_split: nil, int_split: nil,
           mesocycle_weeks: nil,
           split_type: nil,
           macrocycle_number: 1,
           map_assessment: nil,
           osr_limiting_upper: nil, osr_limiting_lower: nil,
           loading_strategies: {},
           **_ignored)
    @acc_structure = acc_structure || Kilo::MicrocycleStructures::DEFAULT_ACC
    @int_structure = int_structure || Kilo::MicrocycleStructures::DEFAULT_INT
    @split_type = split_type
    @macrocycle_number = macrocycle_number
    @acc_split = acc_split
    @int_split = int_split
    @mesocycle_weeks = mesocycle_weeks || [3, 3, 3, 3]
    @osr_limiting_upper = osr_limiting_upper
    @osr_limiting_lower = osr_limiting_lower
    @loading_strategies = loading_strategies || {}
    annotations = []

    # Step 1: MAP assessment (optional)
    movement_result = nil
    if map_assessment&.map_progressions&.any?
      movement_result = @map_engine.call(map_assessment)
      annotations.concat(movement_result.annotations)
    end

    # Step 2: Strength ratio calculation + limiting lift identification (optional)
    ratio_result = nil
    if assessment&.prime_eight_lifts&.count.to_i >= 4
      ratio_result = @ratio_calculator.call(assessment)
      annotations.concat(ratio_result.annotations)
    else
      annotations << { step: "ratio_calculation", rule: "No assessment", value: "Skipped", decision: "Using balanced macrocycle template (no limiting lift prioritization)" }
    end

    # Step 3: Periodization model selection
    model_result = @periodization_engine.call(
      goal: goal,
      training_level: client.training_age,
      volume: volume,
      macrocycle_number: @macrocycle_number
    )
    annotations.concat(model_result.annotations)

    # Step 4: Macrocycle structure
    # For OSR, coach-overridden limiting lifts take precedence
    macro_upper = @osr_limiting_upper.presence || ratio_result&.limiting_upper
    macro_lower = @osr_limiting_lower.presence || ratio_result&.limiting_lower
    macro_blueprint = @macrocycle_builder.call(
      limiting_lift_upper: macro_upper,
      limiting_lift_lower: macro_lower,
      goal: goal,
      model_id: model_result.model_id,
      mesocycle_weeks: @mesocycle_weeks,
      macrocycle_number: @macrocycle_number
    )
    annotations.concat(macro_blueprint.annotations)

    # Step 5-7: For each mesocycle, select split + methods + generate sessions
    mesocycle_data = if goal.to_s == "optimizing_strength_ratios"
      build_osr_mesocycles(
        macro_blueprint: macro_blueprint,
        model_result: model_result,
        client: client,
        ratio_result: ratio_result,
        frequency: frequency,
        annotations: annotations
      )
    else
      build_standard_mesocycles(
        macro_blueprint: macro_blueprint,
        model_result: model_result,
        movement_result: movement_result,
        client: client,
        goal: goal,
        frequency: frequency,
        annotations: annotations
      )
    end

    # Persist everything in a transaction
    program = persist!(
      client: client,
      goal: goal,
      volume: volume,
      frequency: frequency,
      model_id: model_result.model_id,
      macrocycle_number: @macrocycle_number,
      ratio_result: ratio_result,
      movement_result: movement_result,
      mesocycle_data: mesocycle_data,
      annotations: annotations
    )

    # Populate target weights from logged history / PrimeEight E1RMs
    @loading_calculator.call(program)

    program
  end

  private

  def select_split_safe(goal:, phase:, training_level:, frequency:)
    @split_selector.call(
      goal: goal,
      phase: phase,
      training_level: training_level,
      frequency: frequency
    )
  rescue Kilo::TrainingSplitSelector::SplitNotFound => e
    # Return nil, session generator will use default split
    result = Kilo::TrainingSplitSelector::SplitBlueprint.new(
      split_structure: default_split(frequency),
      frequency: frequency
    )
    result.annotate(
      step: "training_split_selection",
      rule: "Fallback to default split",
      value: e.message,
      decision: "Using default #{frequency}x/week split (seed data not yet available)"
    )
    result
  end

  # ── Standard program generation (non-OSR) ──────────────────────────

  def build_standard_mesocycles(macro_blueprint:, model_result:, movement_result:, client:, goal:, frequency:, annotations:)
    macro_blueprint.mesocycles.map do |meso|
      # Step 5: Training split (use coach-selected if provided)
      is_acc = meso[:phase] == :accumulation
      coach_split = is_acc ? @acc_split : @int_split

      split_result = if coach_split
        cs_struct = coach_split.split_structure
        cs_struct = JSON.parse(cs_struct) if cs_struct.is_a?(String)
        result = Kilo::TrainingSplitSelector::SplitBlueprint.new(
          split_structure: cs_struct, frequency: coach_split.frequency
        )
        result.annotate(step: "training_split_selection", rule: "Coach-selected split",
          value: "#{coach_split.goal.titleize} / #{coach_split.training_level.capitalize} / #{coach_split.frequency}x",
          decision: "Using coach-selected training split")
        result
      else
        select_split_safe(goal: goal, phase: meso[:phase],
          training_level: client.training_age, frequency: frequency)
      end
      annotations.concat(split_result.annotations) if split_result

      # Step 6: Training methods
      method_result = @method_timer.call(
        phase: meso[:phase],
        goal: goal,
        training_level: client.training_age
      )
      annotations.concat(method_result.annotations)

      # Step 7: Generate sessions for each week in this mesocycle
      meso_structure = if @acc_structure != Kilo::MicrocycleStructures::DEFAULT_ACC || @int_structure != Kilo::MicrocycleStructures::DEFAULT_INT
        meso[:phase] == :accumulation ? @acc_structure : @int_structure
      else
        Kilo::MicrocycleStructures.defaults_for(meso[:phase], frequency, split_type: @split_type)
      end

      loading_strategy = @loading_strategies[meso[:number]] || @loading_strategies[meso[:number].to_s]

      weeks = (1..meso[:weeks]).map do |week_num|
        rep_scheme_record = model_result.rep_schemes.find_by(phase: meso[:seed_phase])

        global_week = meso[:week_start] + week_num - 1
        generic_split = if frequency == 3 && @split_type == "upper_lower"
          Kilo::MicrocycleStructures.three_day_upper_lower_split(global_week)
        elsif frequency == 3 && @split_type == "full_body"
          Kilo::MicrocycleStructures.three_day_full_body_split
        else
          split_result&.split_structure || default_split(frequency)
        end

        week_split = generic_split.transform_values do |st|
          meso_structure[st] || st
        end

        session_result = @session_generator.call(
          split_structure: week_split,
          rep_scheme: rep_scheme_record&.rep_scheme,
          intensity_pct: rep_scheme_record&.intensity_pct,
          microcycle_structure: meso_structure,
          methods: method_result.methods,
          movement_result: movement_result,
          phase: meso[:phase]
        )
        annotations.concat(session_result.annotations)

        # Apply mesocycle loading to A-series Standard Set exercises
        a_sets, a_reps = @session_generator.send(:parse_rep_scheme, rep_scheme_record&.rep_scheme)
        if a_reps.is_a?(Integer) && loading_strategy.present?
          session_result.sessions.each do |session|
            session[:exercises].each do |ex|
              next unless ex[:position].to_s.start_with?("A")
              ex[:sets] = Kilo::MesocycleLoading.adjust_sets(
                base_sets: a_sets,
                strategy: loading_strategy,
                week_in_meso: week_num,
                total_weeks: meso[:weeks]
              )
            end
          end
        end

        { week_number: meso[:week_start] + week_num - 1, sessions: session_result.sessions }
      end

      meso.merge(weeks: weeks, loading_strategy: loading_strategy)
    end
  end

  # ── OSR program generation ───────────────────────────────────────────

  def build_osr_mesocycles(macro_blueprint:, model_result:, client:, ratio_result:, frequency:, annotations:)
    osr_generator = Kilo::OsrSessionGenerator.new(training_level: client.training_age)

    # Coach-overridden limiting lifts take precedence over ratio calculator
    limiting_upper = (@osr_limiting_upper.presence || ratio_result&.limiting_upper)&.to_sym
    limiting_lower = (@osr_limiting_lower.presence || ratio_result&.limiting_lower)&.to_sym

    unless limiting_upper || limiting_lower
      raise SeedDataMissing, "At least one limiting lift must be selected for an Optimizing Strength Ratios program."
    end

    macro_blueprint.mesocycles.map do |meso|
      # Parse session types from macrocycle template JSONB
      upper = parse_template_sessions(meso[:upper_sessions])
      lower = parse_template_sessions(meso[:lower_sessions])

      # Get rep scheme for template-mode phases (Acc1, Int2)
      rep_scheme_record = model_result.rep_schemes.find_by(phase: meso[:seed_phase])

      weeks = (1..meso[:weeks]).map do |week_num|
        session_result = osr_generator.call(
          phase: meso[:seed_phase],
          seed_phase: meso[:seed_phase],
          upper_sessions: upper,
          lower_sessions: lower,
          limiting_lift_upper: limiting_upper,
          limiting_lift_lower: limiting_lower,
          rep_scheme: rep_scheme_record&.rep_scheme,
          frequency: frequency
        )
        annotations.concat(session_result.annotations)

        { week_number: meso[:week_start] + week_num - 1, sessions: session_result.sessions }
      end

      meso.merge(weeks: weeks)
    end
  end

  # Parse JSONB session structure from KiloMacrocycleTemplate into an array
  # of session type strings. E.g. {"session_1":"overhead_press","session_2":"bench_press"}
  # → ["overhead_press", "bench_press"]
  def parse_template_sessions(sessions_json)
    return [] unless sessions_json

    parsed = sessions_json.is_a?(String) ? JSON.parse(sessions_json) : sessions_json
    parsed.sort_by { |k, _| k.to_s }.map { |_, v| v }
  end

  def default_split(frequency)
    case frequency
    when 2
      { "mon" => "full_body_1", "thu" => "full_body_2" }
    when 3
      # Default 3x split — overridden per-week for upper/lower rotation
      { "mon" => "full_body_1", "wed" => "full_body_2", "fri" => "full_body_3" }
    when 4
      { "mon" => "upper_body_1", "tue" => "lower_body_1", "thu" => "upper_body_2", "fri" => "lower_body_2" }
    else
      { "mon" => "upper_body_1", "tue" => "lower_body_1", "thu" => "upper_body_2", "fri" => "lower_body_2" }
    end
  end

  def persist!(client:, goal:, volume:, frequency:, model_id:, macrocycle_number:, ratio_result:, movement_result:, mesocycle_data:, annotations:)
    ActiveRecord::Base.transaction do
      # Archive existing active program
      client.active_program&.archive!

      # Build generation metadata with version
      metadata = {
        metadata_version: 1,
        generated_at: Time.current.iso8601,
        model_id: model_id,
        macrocycle_number: macrocycle_number,
        limiting_upper: (@osr_limiting_upper.presence || ratio_result&.limiting_upper).to_s,
        limiting_lower: (@osr_limiting_lower.presence || ratio_result&.limiting_lower).to_s,
        ratios: ratio_result ? ratio_result.ratios.transform_values { |v| v.except(:lift) } : {},
        map_applied: movement_result.present?,
        map_levels: movement_result&.levels&.transform_values { |v| { level: v[:level], passed: v.dig(:all_entries, 0, :passed) } },
        acc_microcycle: @acc_structure,
        int_microcycle: @int_structure,
        annotations: annotations
      }

      # Create program
      program = client.programs.create!(
        goal: goal,
        training_level: client.training_age,
        volume: volume,
        frequency: frequency,
        limiting_lift_upper: map_limiting_to_enum(@osr_limiting_upper.presence || ratio_result&.limiting_upper, :upper),
        limiting_lift_lower: map_limiting_to_enum(@osr_limiting_lower.presence || ratio_result&.limiting_lower, :lower),
        periodization_model: model_id,
        macrocycle_number: macrocycle_number,
        split_type: @split_type,
        status: :active,
        generation_metadata: metadata
      )

      # Create macrocycle (1 for MVP)
      macrocycle = program.macrocycles.create!(number: 1, goal_focus: goal)

      # Create mesocycles, microcycles, sessions, exercises, sets
      mesocycle_data.each do |meso_data|
        mesocycle = macrocycle.mesocycles.create!(
          phase: meso_data[:phase],
          number: meso_data[:number],
          loading_strategy: meso_data[:loading_strategy]
        )

        meso_data[:weeks].each do |week_data|
          microcycle = mesocycle.microcycles.create!(week_number: week_data[:week_number])

          week_data[:sessions].each do |session_data|
            session = microcycle.training_sessions.create!(
              day: day_to_integer(session_data[:day]),
              session_type: session_data[:session_type]
            )

            session_data[:exercises].each do |ex_data|
              sets_count = ex_data[:sets].is_a?(Integer) ? ex_data[:sets] : ex_data[:sets].to_s.to_i

              session_exercise = session.session_exercises.create!(
                kilo_exercise_id: ex_data[:kilo_exercise_id],
                exercise_name: ex_data[:exercise_name],
                position: ex_data[:position],
                sets: [sets_count, 1].max,
                tempo: ex_data[:tempo],
                rest_seconds: ex_data[:rest_seconds] || 60,
                group: ex_data[:group],
                group_type: ex_data[:group_type],
                map_adjusted: ex_data[:map_adjusted] || false
              )

              # Parse per-set reps: "8,8,6,6,4,4" → [8,8,6,6,4,4], "3x12" → [12,12,12]
              rep_values = parse_per_set_reps(ex_data[:target_reps].to_s, [sets_count, 1].max)

              [sets_count, 1].max.times do |i|
                session_exercise.exercise_sets.create!(
                  set_number: i + 1,
                  target_reps: rep_values[i] || rep_values.last || 0,
                  target_weight: 0 # To be calculated from E1RM + intensity_pct
                )
              end
            end
          end
        end
      end

      program
    end
  end

  # Parses rep scheme into per-set rep values.
  #   "8,8,6,6,4,4" → [8, 8, 6, 6, 4, 4]
  #   "12,10,8,6"   → [12, 10, 8, 6]
  #   "3x12"        → [12, 12, 12]
  #   "12"          → [12]
  #   "6-10"        → [6] (range: use low end)
  def parse_per_set_reps(rep_string, sets_count)
    return [1] unless rep_string.present?

    str = rep_string.to_s.strip

    # Handle "Max" — default to a reasonable rep count
    return [1] if str.casecmp("max").zero?

    # Handle Con-Ecc combo notation: "4+2" → 6 total
    if str.include?("+")
      total = str.split("+").map(&:to_i).sum
      return [total]
    end

    if str.include?(",")
      reps = str.split(",").map { |r| r.strip.to_i }
      # Ensure no zeros from non-numeric parts
      reps.map { |r| [r, 1].max }
    elsif str.include?("x")
      count, reps = str.split("x").map(&:to_i)
      Array.new([count, 1].max, [reps, 1].max)
    elsif str.include?("-")
      [[str.split("-").first.to_i, 1].max]
    else
      [[str.to_i, 1].max]
    end
  end

  def map_limiting_to_enum(exercise, region)
    return nil unless exercise
    "#{region}_#{exercise}"
  end

  def day_to_integer(day)
    %w[mon tue wed thu fri sat sun].index(day.to_s.downcase) || 0
  end
end
