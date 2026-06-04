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
end
