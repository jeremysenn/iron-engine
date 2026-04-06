class ProgramsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_program, only: %i[show]

  def new
    @assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first
    @has_assessment = @assessment&.prime_eight_lifts&.any?
    @frequency = (params[:frequency] || 4).to_i
    @training_level = @client.training_age
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
      map_assessment: @client.map_assessments.order(assessed_at: :desc).first
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
    params.require(:program).permit(:goal, :volume, :frequency, :status)
  end
end
