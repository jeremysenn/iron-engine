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
           map_assessment: nil, **_ignored)
    @acc_structure = acc_structure || Kilo::MicrocycleStructures::DEFAULT_ACC
    @int_structure = int_structure || Kilo::MicrocycleStructures::DEFAULT_INT
    @acc_split = acc_split
    @int_split = int_split
    @mesocycle_weeks = mesocycle_weeks || [3, 3, 3, 3]
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
      volume: volume
    )
    annotations.concat(model_result.annotations)

    # Step 4: Macrocycle structure
    macro_blueprint = @macrocycle_builder.call(
      limiting_lift_upper: ratio_result&.limiting_upper,
      limiting_lift_lower: ratio_result&.limiting_lower,
      goal: goal,
      model_id: model_result.model_id,
      mesocycle_weeks: @mesocycle_weeks
    )
    annotations.concat(macro_blueprint.annotations)

    # Step 5-7: For each mesocycle, select split + methods + generate sessions
    mesocycle_data = macro_blueprint.mesocycles.map do |meso|
      # Step 5: Training split (use coach-selected if provided)
      is_acc = meso[:phase] == :accumulation
      coach_split = is_acc ? @acc_split : @int_split

      split_result = if coach_split
        result = Kilo::TrainingSplitSelector::SplitBlueprint.new(
          split_structure: coach_split.split_structure, frequency: coach_split.frequency
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
      weeks = (1..meso[:weeks]).map do |week_num|
        # Get rep scheme for this phase from the periodization model
        # seed_phase maps mesocycle position to the correct row in seed data
        rep_scheme_record = model_result.rep_schemes.find_by(phase: meso[:seed_phase])

        # Select microcycle structure based on phase
        is_acc = meso[:phase] == :accumulation
        current_structure = is_acc ? @acc_structure : @int_structure

        session_result = @session_generator.call(
          split_structure: split_result&.split_structure || default_split(frequency),
          rep_scheme: rep_scheme_record&.rep_scheme,
          intensity_pct: rep_scheme_record&.intensity_pct,
          microcycle_structure: current_structure,
          methods: method_result.methods,
          movement_result: movement_result,
          phase: meso[:phase]
        )
        annotations.concat(session_result.annotations)

        { week_number: meso[:week_start] + week_num - 1, sessions: session_result.sessions }
      end

      meso.merge(weeks: weeks)
    end

    # Persist everything in a transaction
    program = persist!(
      client: client,
      goal: goal,
      volume: volume,
      frequency: frequency,
      model_id: model_result.model_id,
      ratio_result: ratio_result,
      mesocycle_data: mesocycle_data,
      annotations: annotations
    )

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

  def default_split(frequency)
    case frequency
    when 2
      { "mon" => "upper_body_1", "thu" => "lower_body_1" }
    when 3
      { "mon" => "upper_body_1", "wed" => "lower_body_1", "fri" => "upper_body_2" }
    when 4
      { "mon" => "upper_body_1", "tue" => "lower_body_1", "thu" => "upper_body_2", "fri" => "lower_body_2" }
    else
      { "mon" => "upper_body_1", "tue" => "lower_body_1", "thu" => "upper_body_2", "fri" => "lower_body_2" }
    end
  end

  def persist!(client:, goal:, volume:, frequency:, model_id:, ratio_result:, mesocycle_data:, annotations:)
    ActiveRecord::Base.transaction do
      # Archive existing active program
      client.active_program&.archive!

      # Build generation metadata with version
      metadata = {
        metadata_version: 1,
        generated_at: Time.current.iso8601,
        model_id: model_id,
        limiting_upper: ratio_result&.limiting_upper.to_s,
        limiting_lower: ratio_result&.limiting_lower.to_s,
        ratios: ratio_result ? ratio_result.ratios.transform_values { |v| v.except(:lift) } : {},
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
        limiting_lift_upper: ratio_result ? map_limiting_to_enum(ratio_result.limiting_upper, :upper) : nil,
        limiting_lift_lower: ratio_result ? map_limiting_to_enum(ratio_result.limiting_lower, :lower) : nil,
        periodization_model: model_id,
        status: :active,
        generation_metadata: metadata
      )

      # Create macrocycle (1 for MVP)
      macrocycle = program.macrocycles.create!(number: 1, goal_focus: goal)

      # Create mesocycles, microcycles, sessions, exercises, sets
      mesocycle_data.each do |meso_data|
        mesocycle = macrocycle.mesocycles.create!(
          phase: meso_data[:phase],
          number: meso_data[:number]
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
                rest_seconds: ex_data[:rest_seconds] || 60
              )

              [sets_count, 1].max.times do |i|
                session_exercise.exercise_sets.create!(
                  set_number: i + 1,
                  target_reps: ex_data[:target_reps].to_s.split("-").first.to_i,
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

  def map_limiting_to_enum(exercise, region)
    return nil unless exercise
    "#{region}_#{exercise}"
  end

  def day_to_integer(day)
    %w[mon tue wed thu fri sat sun].index(day.to_s.downcase) || 0
  end
end
