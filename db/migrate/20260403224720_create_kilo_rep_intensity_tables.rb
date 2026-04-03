class CreateKiloRepIntensityTables < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_rep_intensity_tables do |t|
      t.integer :reps
      t.decimal :intensity_pct

      t.timestamps
    end

    add_index :kilo_rep_intensity_tables, :reps, unique: true
  end
end
