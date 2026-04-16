class ProgramsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_program, only: %i[show edit update]

  def new
    @assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first
    @has_assessment = @assessment&.prime_eight_lifts&.any?
    @map_assessment = @client.map_assessments.order(assessed_at: :desc).first
    @has_map_assessment = @map_assessment&.map_progressions&.any?
    @frequency = (params[:frequency] || 4).to_i
    @training_level = @client.training_age

    # Calculate limiting lifts for OSR goal display
    @limiting_lifts = nil
    if @has_assessment && @assessment.prime_eight_lifts.count >= 4
      begin
        ratio_result = Kilo::StrengthRatioCalculator.new.call(@assessment)
        @limiting_lifts = {
          upper: ratio_result.limiting_upper,
          lower: ratio_result.limiting_lower,
          ratios: ratio_result.ratios
        }
      rescue StandardError
        # Silently ignore — OSR option will still show but without limiting lift preview
      end
    end
  end

  def rep_scheme_preview
    training_level = @client.training_age.to_s
    volume = params[:volume].to_s
    macrocycle_number = (params[:macrocycle_number] || 1).to_i

    model_id = Kilo::PeriodizationEngine::MODEL_MAP[[training_level, volume]]
    records = KiloPeriodizationModel.where(model_id: model_id, macrocycle_number: macrocycle_number).order(:phase)

    phases = records.map do |r|
      { phase: r.phase, rep_scheme: r.rep_scheme, intensity_pct: r.intensity_pct&.to_f }
    end

    render json: { model_id: model_id, macrocycle_number: macrocycle_number, phases: phases }
  end

  # Turbo Frame endpoint: returns microcycle/split options for selected frequency
  def form_options
    @frequency = (params[:frequency] || 4).to_i
    @training_level = @client.training_age
    @goal = params[:goal]
    render partial: "programs/form_options", locals: {
      frequency: @frequency, training_level: @training_level, goal: @goal
    }
  end

  def create
    assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first

    acc_structure = Kilo::MicrocycleStructures.from_params(params[:acc_structure])
    int_structure = Kilo::MicrocycleStructures.from_params(params[:int_structure])

    # Load selected training splits (or use defaults)
    acc_split = params[:acc_split_id].present? ? KiloTrainingSplit.find(params[:acc_split_id]) : nil
    int_split = params[:int_split_id].present? ? KiloTrainingSplit.find(params[:int_split_id]) : nil

    mesocycle_weeks = [
      (params[:acc1_weeks] || 3).to_i,
      (params[:int1_weeks] || 3).to_i,
      (params[:acc2_weeks] || 3).to_i,
      (params[:int2_weeks] || 3).to_i
    ]

    loading_strategies = {
      1 => params[:loading_strategy_1].presence,
      2 => params[:loading_strategy_2].presence,
      3 => params[:loading_strategy_3].presence,
      4 => params[:loading_strategy_4].presence
    }

    generator = Kilo::ProgramGenerator.new
    @program = generator.call(
      client: @client,
      assessment: assessment,
      goal: params[:goal],
      volume: params[:volume],
      frequency: params[:frequency].to_i,
      acc_structure: acc_structure,
      int_structure: int_structure,
      acc_split: acc_split,
      int_split: int_split,
      mesocycle_weeks: mesocycle_weeks,
      split_type: params[:split_type],
      macrocycle_number: (params[:macrocycle_number] || 1).to_i,
      map_assessment: params[:apply_map] == "1" ? @client.map_assessments.order(assessed_at: :desc).first : nil,
      osr_limiting_upper: params[:osr_limiting_upper],
      osr_limiting_lower: params[:osr_limiting_lower],
      loading_strategies: loading_strategies
    )

    redirect_to client_program_path(@client, @program), notice: "Program generated."
  rescue Kilo::ProgramGenerator::SeedDataMissing,
         Kilo::StrengthRatioCalculator::MissingBaselineError,
         Kilo::StrengthRatioCalculator::InsufficientDataError,
         Kilo::PeriodizationEngine::SeedDataMissing,
         Kilo::PeriodizationEngine::InvalidGoal,
         Kilo::TrainingSplitSelector::SplitNotFound => e
    redirect_to new_client_program_path(@client), alert: "Generation failed: #{e.message}"
  end

  def show
    @macrocycles = @program.macrocycles.includes(
      mesocycles: { microcycles: { training_sessions: { session_exercises: [:exercise_sets, :kilo_exercise] } } }
    ).order("mesocycles.number", "microcycles.week_number")

    # Build regenerate params from the existing program
    mesocycles = @macrocycles.first&.mesocycles&.order(:number)&.to_a || []
    meso_weeks = mesocycles.map { |m| m.microcycles.count }
    metadata = @program.generation_metadata || {}

    @regenerate_params = {
      goal: @program.goal,
      frequency: @program.frequency,
      volume: @program.volume,
      split_type: @program.split_type,
      macrocycle_number: @program.macrocycle_number || 1,
      acc1_weeks: meso_weeks[0] || 3,
      int1_weeks: meso_weeks[1] || 3,
      acc2_weeks: meso_weeks[2] || 3,
      int2_weeks: meso_weeks[3] || 3,
      apply_map: metadata["map_applied"] ? "1" : "0"
    }

    # Include per-mesocycle loading strategies for regeneration
    mesocycles.each_with_index do |m, i|
      @regenerate_params[:"loading_strategy_#{i + 1}"] = m.loading_strategy if m.loading_strategy.present?
    end

    # Include OSR limiting lifts for regeneration
    if @program.optimizing_strength_ratios?
      @regenerate_params[:osr_limiting_upper] = @program.limiting_lift_upper&.to_s&.delete_prefix("upper_")
      @regenerate_params[:osr_limiting_lower] = @program.limiting_lift_lower&.to_s&.delete_prefix("lower_")
    end

    # Pass microcycle structures if stored
    if metadata["acc_microcycle"].present?
      metadata["acc_microcycle"].each { |k, v| @regenerate_params[:"acc_structure_#{k}"] = v }
    end
    if metadata["int_microcycle"].present?
      metadata["int_microcycle"].each { |k, v| @regenerate_params[:"int_structure_#{k}"] = v }
    end
  end

  def edit
  end

  def update
    if @program.update(program_params)
      redirect_to client_program_path(@client, @program), notice: "Program updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_program
    @program = @client.programs.find(params[:id])
  end

  def program_params
    params.require(:program).permit(:goal, :volume, :frequency, :status, :macrocycle_number)
  end
end
