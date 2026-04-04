class ProgramsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_program, only: %i[show]

  def new
    @assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first

    unless @assessment&.prime_eight_lifts&.any?
      redirect_to client_path(@client), alert: "Run a PrimeEight assessment first."
    end
  end

  def create
    assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first

    unless assessment
      redirect_to client_path(@client), alert: "Run a PrimeEight assessment first."
      return
    end

    generator = Kilo::ProgramGenerator.new
    @program = generator.call(
      client: @client,
      assessment: assessment,
      goal: params[:goal],
      volume: params[:volume],
      frequency: params[:frequency].to_i,
      map_assessment: @client.map_assessments.order(assessed_at: :desc).first
    )

    redirect_to client_program_path(@client, @program), notice: "Program generated."
  rescue Kilo::ProgramGenerator::SeedDataMissing,
         Kilo::StrengthRatioCalculator::MissingBaselineError,
         Kilo::StrengthRatioCalculator::InsufficientDataError,
         Kilo::PeriodizationEngine::SeedDataMissing,
         Kilo::TrainingSplitSelector::SplitNotFound => e
    redirect_to new_client_program_path(@client), alert: "Generation failed: #{e.message}"
  end

  def show
    @macrocycles = @program.macrocycles.includes(
      mesocycles: { microcycles: { training_sessions: { session_exercises: [:exercise_sets, :kilo_exercise] } } }
    ).order("mesocycles.number", "microcycles.week_number")
  end

  private

  def find_program
    @program = @client.programs.find(params[:id])
  end
end
