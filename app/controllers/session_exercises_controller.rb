class SessionExercisesController < ApplicationController
  include Scopeable

  before_action :find_client

  def update
    @exercise = SessionExercise.joins(training_session: { microcycle: { mesocycle: { macrocycle: :program } } })
      .where(programs: { client_id: @client.id })
      .find(params[:id])
    @program = @exercise.training_session.microcycle.mesocycle.macrocycle.program

    # Handle exercise swap (form-based, full page)
    if params[:kilo_exercise_id].present? || params[:exercise_name].present?
      update_exercise_name
      return
    end

    # Handle inline field edits (sets, reps, tempo, rest)
    updates = {}
    updates[:sets] = params[:sets].to_i if params[:sets].present?
    updates[:tempo] = params[:tempo] if params[:tempo].present?
    updates[:rest_seconds] = params[:rest_seconds].to_i if params[:rest_seconds].present?

    @exercise.update!(updates) if updates.any?

    # Handle reps change (stored on exercise_sets)
    if params[:reps].present?
      reps_str = params[:reps].to_s
      if reps_str.include?(",")
        # Per-set reps: "8,8,6,6,4,4"
        rep_values = reps_str.split(",").map { |r| r.strip.to_i }
        @exercise.exercise_sets.order(:set_number).each_with_index do |es, i|
          es.update!(target_reps: rep_values[i] || rep_values.last)
        end
      else
        # Uniform reps: "12"
        @exercise.exercise_sets.update_all(target_reps: reps_str.to_i)
      end
    end

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to client_program_path(@client, @program) }
    end
  end

  private

  def update_exercise_name
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

    return redirect_to(client_workout_path(@client, @exercise.training_session), alert: "No exercise selected.") unless new_name

    session = @exercise.training_session

    if params[:scope] == "mesocycle"
      mesocycle = session.microcycle.mesocycle
      matching = SessionExercise.joins(training_session: :microcycle)
        .where(microcycles: { mesocycle_id: mesocycle.id })
        .where(position: @exercise.position)
        .where(training_sessions: { session_type: session.session_type })

      matching.update_all(exercise_name: new_name, kilo_exercise_id: new_kilo_id)

      redirect_to client_program_path(@client, @program),
        notice: "Exercise updated across all #{matching.count} sessions in #{mesocycle.phase.titleize}."
    else
      @exercise.update!(exercise_name: new_name, kilo_exercise_id: new_kilo_id)
      redirect_to client_program_path(@client, @program), notice: "Exercise updated."
    end
  end
end
