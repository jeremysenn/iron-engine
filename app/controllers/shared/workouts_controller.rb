class Shared::WorkoutsController < SharedController
  before_action :find_session

  # GET /s/:token/workouts/:id
  def show
    @exercises = @session.session_exercises.includes(:exercise_sets, :kilo_exercise).order(:position)
    @program = @session.microcycle.mesocycle.macrocycle.program
  end

  # PATCH /s/:token/workouts/:id
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

    Kilo::LoadingSchemeCalculator.new.recalculate_after_logging(@session)

    redirect_to shared_workout_path(@share_token.token, @session), notice: "Workout saved."
  end

  private

  def find_session
    # Ensure the session belongs to this client's programs
    @session = TrainingSession.joins(microcycle: { mesocycle: { macrocycle: :program } })
      .where(programs: { client_id: @client.id })
      .find(params[:id])
  end

  def sets_params
    params.require(:sets).to_unsafe_h.transform_values { |v| v.slice("actual_weight", "actual_reps") }
  end
end
