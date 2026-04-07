class AddGroupFieldsToSessionExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :session_exercises, :group, :string
    add_column :session_exercises, :group_type, :integer
  end
end
