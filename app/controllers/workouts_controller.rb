class WorkoutsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_session

  # GET /clients/:client_id/workouts/:training_session_id
  # Shows the workout logging form for a specific training session
  def show
    @exercises = @session.session_exercises.includes(:exercise_sets, :kilo_exercise).order(:position)
    @program = @session.microcycle.mesocycle.macrocycle.program
  end

  # PATCH /clients/:client_id/workouts/:training_session_id
  # Saves actual weight and reps for all sets
  def update
    @session.update!(completed_at: params[:completed_at]) if params[:completed_at].present?

    sets_params.each do |set_id, attrs|
      set = ExerciseSet.joins(session_exercise: :training_session)
        .where(training_sessions: { id: @session.id })
        .find(set_id)
      set.update!(
        actual_weight: attrs[:actual_weight],
        actual_reps: attrs[:actual_reps]
      )
    end

    # Recalculate suggested weights for future sessions based on what was just logged
    Kilo::LoadingSchemeCalculator.new.recalculate_after_logging(@session)

    redirect_to client_workout_path(@client, @session), notice: "Workout saved."
  end

  private

  def find_session
    @session = TrainingSession.joins(microcycle: { mesocycle: { macrocycle: :program } })
      .where(programs: { client_id: @client.id })
      .find(params[:id])
  end

  def sets_params
    params.require(:sets).to_unsafe_h.transform_values { |v| v.slice("actual_weight", "actual_reps") }
  end
end
