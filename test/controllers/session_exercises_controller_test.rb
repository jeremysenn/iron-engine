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

  # Bug: a typed custom name was ignored because the swap <select> always
  # submits a kilo_exercise_id, and the controller checked it first.
  test "custom exercise name sticks even when a kilo_exercise_id is also submitted" do
    other_kilo = KiloExercise.create!(name: "Front Squat", body_region: "lower")

    patch client_session_exercise_path(@client, @se),
      params: { kilo_exercise_id: other_kilo.id, exercise_name: "Belt Squat", scope: "workout" }

    @se.reload
    assert_nil @se.kilo_exercise_id, "should not keep a kilo_exercise_id when a custom name is given"
    assert_equal "Belt Squat", @se.read_attribute(:exercise_name)
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
