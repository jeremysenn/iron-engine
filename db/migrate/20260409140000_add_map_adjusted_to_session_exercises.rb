class AddMapAdjustedToSessionExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :session_exercises, :map_adjusted, :boolean, default: false, null: false
  end
end
