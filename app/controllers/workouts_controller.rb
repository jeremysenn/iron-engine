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
    sets_params.each do |set_id, attrs|
      set = ExerciseSet.find(set_id)
      set.update!(
        actual_weight: attrs[:actual_weight],
        actual_reps: attrs[:actual_reps]
      )
    end

    redirect_to client_workout_path(@client, @session), notice: "Workout saved."
  end

  private

  def find_session
    @session = TrainingSession.find(params[:id])
  end

  def sets_params
    params.require(:sets).permit!.to_h
  end
end
