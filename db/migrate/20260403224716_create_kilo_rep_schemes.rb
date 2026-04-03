class CreateKiloRepSchemes < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_rep_schemes do |t|
      t.integer :total_reps
      t.string :rep_pattern
      t.decimal :intensity_pct
      t.string :strength_quality

      t.timestamps
    end
  end
end
