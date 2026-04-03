class CreateKiloExercisePairings < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_exercise_pairings do |t|
      t.references :primary_exercise, null: false, foreign_key: { to_table: :kilo_exercises }
      t.references :paired_exercise, null: false, foreign_key: { to_table: :kilo_exercises }
      t.integer :context

      t.timestamps
    end
  end
end
