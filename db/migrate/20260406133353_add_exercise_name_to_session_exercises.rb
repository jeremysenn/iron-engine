class AddExerciseNameToSessionExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :session_exercises, :exercise_name, :string
  end
end
