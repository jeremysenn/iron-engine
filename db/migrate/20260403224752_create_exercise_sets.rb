class CreateExerciseSets < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_sets do |t|
      t.references :session_exercise, null: false, foreign_key: true
      t.integer :set_number
      t.integer :target_reps
      t.decimal :target_weight
      t.integer :actual_reps
      t.decimal :actual_weight

      t.timestamps
    end
  end
end
