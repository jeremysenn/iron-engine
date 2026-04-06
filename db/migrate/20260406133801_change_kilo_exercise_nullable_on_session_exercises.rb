class ChangeKiloExerciseNullableOnSessionExercises < ActiveRecord::Migration[8.1]
  def change
    change_column_null :session_exercises, :kilo_exercise_id, true
  end
end
