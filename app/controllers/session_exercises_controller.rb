class SessionExercisesController < ApplicationController
  include Scopeable

  before_action :find_client

  def update
    @exercise = SessionExercise.find(params[:id])

    new_name = nil
    new_kilo_id = nil

    if params[:kilo_exercise_id].present?
      kilo_ex = KiloExercise.find(params[:kilo_exercise_id])
      new_name = kilo_ex.name
      new_kilo_id = kilo_ex.id
    elsif params[:exercise_name].present?
      new_name = params[:exercise_name]
      new_kilo_id = nil
    end

    if new_name
      if params[:scope] == "mesocycle"
        # Update all matching exercises in the same mesocycle (same position + session_type)
        session = @exercise.training_session
        mesocycle = session.microcycle.mesocycle

        matching = SessionExercise.joins(training_session: :microcycle)
          .where(microcycles: { mesocycle_id: mesocycle.id })
          .where(position: @exercise.position)
          .where(training_sessions: { session_type: session.session_type })

        matching.update_all(exercise_name: new_name, kilo_exercise_id: new_kilo_id)

        redirect_to client_workout_path(@client, session),
          notice: "Exercise updated across all #{matching.count} sessions in #{mesocycle.phase.titleize} #{mesocycle.number}."
      else
        # Update only this one session exercise
        @exercise.update!(exercise_name: new_name, kilo_exercise_id: new_kilo_id)
        redirect_to client_workout_path(@client, @exercise.training_session), notice: "Exercise updated."
      end
    else
      redirect_to client_workout_path(@client, @exercise.training_session), alert: "No exercise selected."
    end
  end
end
