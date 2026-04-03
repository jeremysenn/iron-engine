class CreateKiloOptimalRatios < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_optimal_ratios do |t|
      t.integer :exercise
      t.integer :body_region
      t.decimal :ratio_pct

      t.timestamps
    end
  end
end
