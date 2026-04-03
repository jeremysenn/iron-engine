class CreatePrimeEightLifts < ActiveRecord::Migration[8.1]
  def change
    create_table :prime_eight_lifts do |t|
      t.references :prime_eight_assessment, null: false, foreign_key: true
      t.integer :exercise
      t.decimal :weight
      t.integer :reps
      t.decimal :e1rm
      t.integer :formula_used

      t.timestamps
    end
  end
end
