class AddPrimaryToSessionExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :session_exercises, :primary_exercise, :boolean, default: false, null: false
  end
end
