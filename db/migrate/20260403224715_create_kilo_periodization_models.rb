class CreateKiloPeriodizationModels < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_periodization_models do |t|
      t.string :model_id
      t.integer :macrocycle_number
      t.integer :phase
      t.string :rep_scheme
      t.decimal :intensity_pct

      t.timestamps
    end

    add_index :kilo_periodization_models, [ :model_id, :macrocycle_number, :phase ], unique: true, name: "idx_kilo_period_model_macro_phase"
  end
end
