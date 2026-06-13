require "test_helper"

class SessionExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)

    @client = @user.clients.create!(first_name: "Test", last_name: "Client", training_age: :intermediate)
    @program = @client.programs.create!(
      goal: :balanced, training_level: :intermediate, volume: :medium,
      frequency: 3, status: :active, macrocycle_number: 1
    )
    macrocycle = @program.macrocycles.create!(number: 1)
    mesocycle = macrocycle.mesocycles.create!(number: 1, phase: :accumulation)
    microcycle = mesocycle.microcycles.create!(week_number: 1)
    @session = microcycle.training_sessions.create!(day: 0, session_type: :full_body)
    @existing_kilo = KiloExercise.create!(name: "Back Squat", body_region: "lower")
    @se = @session.session_exercises.create!(
      position: "A1", sets: 3, rest_seconds: 120, kilo_exercise_id: @existing_kilo.id
    )
  end

  # A typed custom name was ignored because the swap <select> always submits a
  # kilo_exercise_id and the controller checked it first. It now wins, and the
  # custom exercise is saved to the coach's library for reuse.
  test "custom exercise name creates a per-user custom exercise and links it" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    assert_difference -> { KiloExercise.count }, 1 do
      patch client_session_exercise_path(@client, @se),
        params: { kilo_exercise_id: other_kilo.id, exercise_name: "Belt Squat", scope: "workout" }
    end

    created = KiloExercise.find_by(name: "Belt Squat", user: @user, custom: true)
    assert created, "should add the custom exercise to the coach's library"

    @se.reload
    assert_equal created.id, @se.kilo_exercise_id, "custom name should win over the submitted kilo_exercise_id"
    assert_equal "Belt Squat", @se.exercise_name
  end

  test "custom name reuses an existing custom exercise instead of duplicating" do
    existing = KiloExercise.create!(name: "Belt Squat", user: @user, custom: true)

    assert_no_difference -> { KiloExercise.count } do
      patch client_session_exercise_path(@client, @se),
        params: { exercise_name: "Belt Squat", scope: "workout" }
    end

    @se.reload
    assert_equal existing.id, @se.kilo_exercise_id
  end

  test "custom name matching a standard exercise reuses it (no custom duplicate)" do
    standard = KiloExercise.create!(name: "Zercher Squat", body_region: "lower") # custom: false by default

    assert_no_difference -> { KiloExercise.count } do
      patch client_session_exercise_path(@client, @se),
        params: { exercise_name: "Zercher Squat", scope: "workout" }
    end

    @se.reload
    assert_equal standard.id, @se.kilo_exercise_id
  end

  test "selecting a kilo exercise (blank custom name) uses the database exercise" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    patch client_session_exercise_path(@client, @se),
      params: { kilo_exercise_id: other_kilo.id, exercise_name: "", scope: "workout" }

    @se.reload
    assert_equal other_kilo.id, @se.kilo_exercise_id
    assert_equal "Front Squat", @se.read_attribute(:exercise_name)
  end

  test "whitespace-only custom name falls back to the kilo selection" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    patch client_session_exercise_path(@client, @se),
      params: { kilo_exercise_id: other_kilo.id, exercise_name: "   ", scope: "workout" }

    @se.reload
    assert_equal other_kilo.id, @se.kilo_exercise_id
  end

  # An inline swap from the Log Workout page (X-Inline-Swap header) returns just
  # the re-rendered card and does NOT redirect, so the page's JS can replace
  # that one card and the unsaved weight/reps in the other cards survive.
  test "inline swap returns the re-rendered card and does not redirect" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    patch client_session_exercise_path(@client, @se),
      params: { kilo_exercise_id: other_kilo.id, scope: "workout" },
      headers: { "X-Inline-Swap" => "1" }

    assert_response :success
    assert_match "exercise-card-#{@se.id}", @response.body
    assert_match "Front Squat", @response.body
    assert_equal other_kilo.id, @se.reload.kilo_exercise_id
  end

  # The mesocycle-scope inline swap reloads @exercise before rendering, so the
  # returned card must show the NEW exercise (not the stale pre-swap name).
  test "inline mesocycle-scope swap renders the reloaded card" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    patch client_session_exercise_path(@client, @se),
      params: { kilo_exercise_id: other_kilo.id, scope: "mesocycle" },
      headers: { "X-Inline-Swap" => "1" }

    assert_response :success
    assert_match "exercise-card-#{@se.id}", @response.body
    assert_match "Front Squat", @response.body
    assert_equal other_kilo.id, @se.reload.kilo_exercise_id
  end

  # Without the inline header (no JS / the program page) the swap keeps the
  # full-page redirect to the program.
  test "swap without the inline header still redirects to the program page" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    patch client_session_exercise_path(@client, @se),
      params: { kilo_exercise_id: other_kilo.id, scope: "workout" }

    assert_redirected_to client_program_path(@client, @program)
    assert_equal other_kilo.id, @se.reload.kilo_exercise_id
  end

  # Request 1: the swap search must surface the coach's user-created exercises,
  # grouped under a clear "My Custom Exercises" heading (region-less customs
  # otherwise sort under a blank optgroup).
  test "workout swap select lists the coach's custom exercises under a labeled group" do
    KiloExercise.create!(name: "Belt Squat", user: @user, custom: true)

    get client_workout_path(@client, @session)

    assert_response :success
    assert_select "optgroup[label='My Custom Exercises'] option", text: "Belt Squat"
  end

  # ── Adding a new exercise to an existing session ─────────────────────────

  test "adding a library exercise creates a session exercise with its sets" do
    bicep_curl = KiloExercise.create!(name: "Bicep Curl", body_region: "upper")

    assert_difference -> { @session.session_exercises.count }, 1 do
      assert_difference -> { ExerciseSet.count }, 3 do
        post client_session_exercises_path(@client),
          params: { training_session_id: @session.id, kilo_exercise_id: bicep_curl.id,
                    group: "B", sets: 3, reps: "10", tempo: "3-0-1-0", rest_seconds: 60, scope: "exercise" }
      end
    end

    assert_redirected_to client_program_path(@client, @program)
    added = @session.session_exercises.order(:created_at).last
    assert_equal "B1", added.position, "first exercise in a new group is numbered 1"
    assert_equal bicep_curl.id, added.kilo_exercise_id
    assert_equal 3, added.sets
    assert_equal "3-0-1-0", added.tempo
    assert_equal 60, added.rest_seconds
    assert_equal [ 1, 2, 3 ], added.exercise_sets.order(:set_number).map(&:set_number)
    assert_equal [ 10, 10, 10 ], added.exercise_sets.order(:set_number).map(&:target_reps)
  end

  test "auto-numbers the position within an existing group" do
    @session.session_exercises.create!(position: "B1", sets: 3, rest_seconds: 60)
    curl = KiloExercise.create!(name: "Hammer Curl", body_region: "upper")

    post client_session_exercises_path(@client),
      params: { training_session_id: @session.id, kilo_exercise_id: curl.id,
                group: "B", sets: 3, reps: "10", scope: "exercise" }

    assert_equal "B2", @session.session_exercises.order(:created_at).last.position
  end

  test "adding with a custom name saves it to the coach library and links it" do
    assert_difference -> { KiloExercise.count }, 1 do
      post client_session_exercises_path(@client),
        params: { training_session_id: @session.id, exercise_name: "Sissy Squat",
                  group: "C", sets: 4, reps: "12", scope: "exercise" }
    end

    custom = KiloExercise.find_by(name: "Sissy Squat", user: @user, custom: true)
    assert custom
    added = @session.session_exercises.order(:created_at).last
    assert_equal custom.id, added.kilo_exercise_id
    assert_equal "C1", added.position
  end

  test "per-set reps create one set per value" do
    curl = KiloExercise.create!(name: "Preacher Curl", body_region: "upper")

    post client_session_exercises_path(@client),
      params: { training_session_id: @session.id, kilo_exercise_id: curl.id,
                group: "B", sets: 3, reps: "8,6,4", scope: "exercise" }

    added = @session.session_exercises.order(:created_at).last
    assert_equal [ 8, 6, 4 ], added.exercise_sets.order(:set_number).map(&:target_reps)
  end

  test "invalid sets or reps redirects without creating anything" do
    curl = KiloExercise.create!(name: "Cable Curl", body_region: "upper")

    assert_no_difference -> { SessionExercise.count } do
      post client_session_exercises_path(@client),
        params: { training_session_id: @session.id, kilo_exercise_id: curl.id,
                  group: "B", sets: 0, reps: "10", scope: "exercise" }
    end

    assert_redirected_to client_program_path(@client, @program)
    assert_no_difference -> { SessionExercise.count } do
      post client_session_exercises_path(@client),
        params: { training_session_id: @session.id, kilo_exercise_id: curl.id,
                  group: "B", sets: 3, reps: "0", scope: "exercise" }
    end
  end

  test "mesocycle scope adds the exercise to every matching session in the mesocycle" do
    mesocycle = @session.microcycle.mesocycle
    other_micro = mesocycle.microcycles.create!(week_number: 2)
    other_session = other_micro.training_sessions.create!(day: 0, session_type: :full_body)
    # A different session type in the same mesocycle must NOT receive the exercise.
    upper = other_micro.training_sessions.create!(day: 1, session_type: :upper_body_1)
    curl = KiloExercise.create!(name: "Concentration Curl", body_region: "upper")

    assert_difference -> { SessionExercise.count }, 2 do
      post client_session_exercises_path(@client),
        params: { training_session_id: @session.id, kilo_exercise_id: curl.id,
                  group: "B", sets: 3, reps: "10", scope: "mesocycle" }
    end

    assert_equal 1, @session.session_exercises.where(kilo_exercise_id: curl.id).count
    assert_equal 1, other_session.session_exercises.where(kilo_exercise_id: curl.id).count
    assert_equal 0, upper.session_exercises.where(kilo_exercise_id: curl.id).count
  end

  test "cannot add an exercise to another coach's session" do
    other_user = users(:two)
    other_client = other_user.clients.create!(first_name: "Other", last_name: "Client", training_age: :intermediate)
    other_program = other_client.programs.create!(goal: :balanced, training_level: :intermediate, volume: :medium, frequency: 3, status: :active)
    other_macro = other_program.macrocycles.create!(number: 1)
    other_meso = other_macro.mesocycles.create!(number: 1, phase: :accumulation)
    other_micro = other_meso.microcycles.create!(week_number: 1)
    other_session = other_micro.training_sessions.create!(day: 0, session_type: :full_body)
    curl = KiloExercise.create!(name: "Spider Curl", body_region: "upper")

    # @client (current coach's client) doesn't own other_session, so the scoped
    # lookup misses and renders 404 — nothing is created.
    assert_no_difference -> { SessionExercise.count } do
      post client_session_exercises_path(@client),
        params: { training_session_id: other_session.id, kilo_exercise_id: curl.id,
                  group: "B", sets: 3, reps: "10", scope: "exercise" }
    end
    assert_response :not_found
  end
end
