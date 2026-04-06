class SessionExercisesController < ApplicationController
  include Scopeable

  before_action :find_client

  def update
    @exercise = SessionExercise.find(params[:id])

    if params[:kilo_exercise_id].present?
      kilo_ex = KiloExercise.find(params[:kilo_exercise_id])
      @exercise.update!(kilo_exercise: kilo_ex, exercise_name: kilo_ex.name)
    elsif params[:exercise_name].present?
      @exercise.update!(exercise_name: params[:exercise_name], kilo_exercise_id: nil)
    end

    session = @exercise.training_session
    redirect_to client_workout_path(@client, session), notice: "Exercise updated."
  end
end
