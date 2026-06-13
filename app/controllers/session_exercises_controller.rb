class SessionExercisesController < ApplicationController
  include Scopeable

  before_action :find_client

  # Adds a brand-new exercise to a session (the generator only ever creates
  # exercises at program-build time; this is the one path that inserts one
  # afterward). The coach picks a group letter (A/B/C…) and we auto-number the
  # position within that group. With scope=mesocycle the same exercise is added
  # to every same-session-type session in the mesocycle, mirroring swap.
  def create
    session = TrainingSession.joins(microcycle: { mesocycle: { macrocycle: :program } })
      .where(programs: { client_id: @client.id })
      .find(params[:training_session_id])
    program = session.microcycle.mesocycle.macrocycle.program

    name, kilo_id = resolve_swap_exercise
    return redirect_to(client_program_path(@client, program), alert: "No exercise selected.") unless name

    sets_count = params[:sets].to_i
    rep_values = parse_reps(params[:reps], sets_count)
    if sets_count <= 0 || rep_values.any? { |r| r <= 0 }
      return redirect_to(client_program_path(@client, program), alert: "Enter a valid number of sets and reps.")
    end

    tempo = params[:tempo].presence || "4-0-1-0"
    rest = params[:rest_seconds].presence&.to_i || 90
    group = params[:group].to_s.strip.upcase
    group = "A" unless group.match?(/\A[A-Z]\z/)

    # Same position string across every target session: same-session-type
    # sessions share template structure, so the exercise lands in the same slot.
    position = next_position_in_group(session, group)

    target_sessions =
      if params[:scope] == "mesocycle"
        mesocycle = session.microcycle.mesocycle
        TrainingSession.joins(microcycle: :mesocycle)
          .where(microcycles: { mesocycle_id: mesocycle.id })
          .where(session_type: session.session_type).to_a
      else
        [ session ]
      end

    ActiveRecord::Base.transaction do
      target_sessions.each do |ts|
        se = ts.session_exercises.create!(
          position: position, exercise_name: name, kilo_exercise_id: kilo_id,
          sets: sets_count, tempo: tempo, rest_seconds: rest
        )
        rep_values.each_with_index do |reps, i|
          se.exercise_sets.create!(set_number: i + 1, target_reps: reps)
        end
      end
    end

    notice =
      if params[:scope] == "mesocycle"
        "Added #{name} (#{position}) to all #{target_sessions.size} #{session.session_type.titleize} sessions in this mesocycle."
      else
        "Added #{name} (#{position})."
      end
    redirect_to client_program_path(@client, program), notice: notice
  end

  def update
    @exercise = SessionExercise.joins(training_session: { microcycle: { mesocycle: { macrocycle: :program } } })
      .where(programs: { client_id: @client.id })
      .find(params[:id])
    @program = @exercise.training_session.microcycle.mesocycle.macrocycle.program

    # Handle exercise swap (in-place card for inline workout swaps, redirect elsewhere)
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
    new_name, new_kilo_id = resolve_swap_exercise

    return redirect_to(client_workout_path(@client, @exercise.training_session), alert: "No exercise selected.") unless new_name

    session = @exercise.training_session

    if params[:scope] == "mesocycle"
      mesocycle = session.microcycle.mesocycle
      matching = SessionExercise.joins(training_session: :microcycle)
        .where(microcycles: { mesocycle_id: mesocycle.id })
        .where(position: @exercise.position)
        .where(training_sessions: { session_type: session.session_type })

      matching.update_all(exercise_name: new_name, kilo_exercise_id: new_kilo_id)
      @exercise.reload
      notice = "Exercise updated across all #{matching.count} sessions in #{mesocycle.phase.titleize}."
    else
      @exercise.update!(exercise_name: new_name, kilo_exercise_id: new_kilo_id)
      notice = "Exercise updated."
    end

    # The Log Workout page swaps in place via fetch (X-Inline-Swap header): we
    # return just the re-rendered card so its JS can replace that one card,
    # leaving unsaved weight/reps in the other cards untouched. Every other
    # caller (and the no-JS fallback) keeps the full-page redirect.
    if request.headers["X-Inline-Swap"].present?
      render partial: "workouts/exercise_card",
        locals: { se: @exercise, program: @program }
    else
      redirect_to client_program_path(@client, @program), notice: notice
    end
  end

  # Resolves the chosen exercise from the swap/add form into [name, kilo_id].
  #
  # A custom name takes priority over the dropdown selection. The <select>
  # always submits a kilo_exercise_id (it has no blank option, so the browser
  # auto-selects an option), so checking it first would make a typed custom name
  # impossible to save. This matches the form's hint: "Custom exercise name
  # (leave blank to use selection above)".
  def resolve_swap_exercise
    if params[:exercise_name].present?
      kilo_ex = find_or_create_custom_exercise(params[:exercise_name].strip)
      [ kilo_ex.name, kilo_ex.id ]
    elsif params[:kilo_exercise_id].present?
      kilo_ex = KiloExercise.find(params[:kilo_exercise_id])
      [ kilo_ex.name, kilo_ex.id ]
    else
      [ nil, nil ]
    end
  end

  # Builds a target_reps array of length sets_count from the reps field.
  # Accepts uniform ("12") or per-set ("8,8,6,6"); per-set short of sets_count
  # is padded with the last value, matching the inline reps editor.
  def parse_reps(raw, sets_count)
    return [] if sets_count <= 0

    str = raw.to_s
    if str.include?(",")
      vals = str.split(",").map { |r| r.strip.to_i }
      Array.new(sets_count) { |i| vals[i] || vals.last || 0 }
    else
      Array.new(sets_count, str.to_i)
    end
  end

  # Next free position within a group letter for a session: "B" with B1, B2
  # present → "B3"; an unused letter → "<letter>1".
  def next_position_in_group(session, group)
    numbers = session.session_exercises
      .where("position ~* ?", "^#{group}[0-9]+$")
      .pluck(:position)
      .map { |p| p[/\d+/].to_i }
    "#{group}#{(numbers.max || 0) + 1}"
  end

  # A custom exercise name typed in the swap modal is saved to the coach's
  # exercise library so it's reusable in future swaps (it shows up in the
  # swap dropdown via KiloExercise.available_for). If the name already matches
  # an exercise the coach can see — a standard one or an existing custom — reuse
  # that instead of creating a duplicate.
  def find_or_create_custom_exercise(name)
    KiloExercise.available_for(Current.user).find_by(name: name) ||
      KiloExercise.create!(name: name, user: Current.user, custom: true)
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    # Lost a race to create the same custom name; the other request won.
    KiloExercise.available_for(Current.user).find_by!(name: name)
  end
end
