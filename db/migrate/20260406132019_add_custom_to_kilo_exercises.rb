class AddCustomToKiloExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :kilo_exercises, :custom, :boolean, default: false, null: false
    add_reference :kilo_exercises, :user, null: true, foreign_key: true
  end
end
