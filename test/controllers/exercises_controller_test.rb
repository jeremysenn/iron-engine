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

  # The "Watch Demo" link builds its href from the extracted YouTube id with a
  # literal https scheme (not the raw model attribute), so it can never carry a
  # javascript:/data: payload. Brakeman LinkToHref flagged the old version.
  test "show renders a Watch Demo link with a canonical https YouTube URL" do
    exercise = KiloExercise.create!(name: "Demo Move", body_region: "Upper Body", video_url: "https://youtu.be/dQw4w9WgXcQ")

    get exercise_path(exercise)

    assert_response :success
    assert_select "a[href='https://www.youtube.com/watch?v=dQw4w9WgXcQ']", text: "Watch Demo"
  end

  test "index renders with the search and filter controls" do
    KiloExercise.create!(name: "My Belt Squat", user: @user, custom: true)

    get exercises_path

    assert_response :success
    assert_select "#exercise-search"
    assert_select "#exercise-filters [data-filter='custom']"
    assert_select ".exercise-row[data-custom='true']"
  end

  test "creates a custom exercise with a demo video URL" do
    assert_difference -> { KiloExercise.count }, 1 do
      post exercises_path, params: { kilo_exercise: {
        name: "Demo Move", body_region: "Upper Body", category: "Row",
        video_url: "https://youtu.be/dQw4w9WgXcQ"
      } }
    end

    exercise = KiloExercise.order(:created_at).last
    assert_redirected_to exercise_path(exercise)
    assert_equal "https://youtu.be/dQw4w9WgXcQ", exercise.video_url
    assert exercise.custom?
    assert_equal @user.id, exercise.user_id
  end

  test "rejects a non-YouTube demo video URL on create" do
    assert_no_difference -> { KiloExercise.count } do
      post exercises_path, params: { kilo_exercise: {
        name: "Bad Demo", body_region: "Upper Body", category: "Row",
        video_url: "https://vimeo.com/12345"
      } }
    end

    assert_response :unprocessable_entity
  end

  test "updates the demo video URL on the coach's own custom exercise" do
    custom = KiloExercise.create!(name: "Belt Squat", user: @user, custom: true)

    patch exercise_path(custom), params: { kilo_exercise: { video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ" } }

    assert_redirected_to exercise_path(custom)
    assert_equal "https://www.youtube.com/watch?v=dQw4w9WgXcQ", custom.reload.video_url
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
