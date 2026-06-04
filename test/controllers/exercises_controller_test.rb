require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other = users(:two)
    sign_in_as(@user)
  end

  test "deletes the coach's own custom exercise" do
    custom = KiloExercise.create!(name: "Belt Squat", user: @user, custom: true)

    assert_difference -> { KiloExercise.count }, -1 do
      delete exercise_path(custom)
    end
    assert_redirected_to exercises_path
    assert_nil KiloExercise.find_by(id: custom.id)
  end

  test "blocks deleting a custom exercise that is in use by a program" do
    custom = KiloExercise.create!(name: "Belt Squat", user: @user, custom: true)
    se = build_session_exercise(kilo_exercise: custom)

    assert_no_difference -> { KiloExercise.count } do
      delete exercise_path(custom)
    end
    assert_redirected_to exercise_path(custom)
    assert_match(/in use/i, flash[:alert])
    assert KiloExercise.find_by(id: custom.id), "exercise should still exist"
    assert se.reload.kilo_exercise_id == custom.id
  end

  test "does not allow deleting a standard exercise" do
    standard = KiloExercise.create!(name: "Standard Squat", body_region: "lower") # custom: false

    assert_no_difference -> { KiloExercise.count } do
      delete exercise_path(standard)
    end
    assert_redirected_to exercises_path
    assert KiloExercise.find_by(id: standard.id)
  end

  test "does not allow editing another coach's custom exercise" do
    others = KiloExercise.create!(name: "Their Move", user: @other, custom: true)

    patch exercise_path(others), params: { kilo_exercise: { name: "Hijacked" } }

    assert_redirected_to exercises_path
    assert_equal "Their Move", others.reload.name
  end

  test "does not allow editing a standard exercise" do
    standard = KiloExercise.create!(name: "Standard Squat", body_region: "lower")

    patch exercise_path(standard), params: { kilo_exercise: { name: "Hijacked" } }

    assert_redirected_to exercises_path
    assert_equal "Standard Squat", standard.reload.name
  end

  private

  def build_session_exercise(kilo_exercise:)
    client = @user.clients.create!(first_name: "T", last_name: "C", training_age: :intermediate)
    program = client.programs.create!(
      goal: :balanced, training_level: :intermediate, volume: :medium,
      frequency: 3, status: :active, macrocycle_number: 1
    )
    macro = program.macrocycles.create!(number: 1)
    meso = macro.mesocycles.create!(number: 1, phase: :accumulation)
    micro = meso.microcycles.create!(week_number: 1)
    session = micro.training_sessions.create!(day: 0, session_type: :full_body)
    session.session_exercises.create!(
      position: "A1", sets: 3, rest_seconds: 120, kilo_exercise: kilo_exercise
    )
  end
end
