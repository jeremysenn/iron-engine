class ProgramsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_program, only: %i[show]

  def new
    @assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first
    @has_assessment = @assessment&.prime_eight_lifts&.any?
  end

  def create
    assessment = @client.prime_eight_assessments.order(assessed_at: :desc).first

    generator = Kilo::ProgramGenerator.new
    @program = generator.call(
      client: @client,
      assessment: assessment,
      goal: params[:goal],
      volume: params[:volume],
      frequency: params[:frequency].to_i,
      acc_microcycle: params[:acc_microcycle] || "1",
      int_microcycle: params[:int_microcycle] || "2",
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

  private

  def find_program
    @program = @client.programs.find(params[:id])
  end
end
