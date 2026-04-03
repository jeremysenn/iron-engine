class CreateStrengthRatioAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :strength_ratio_analyses do |t|
      t.references :prime_eight_lift, null: false, foreign_key: true
      t.decimal :current_ratio
      t.decimal :optimal_ratio
      t.decimal :discrepancy
      t.boolean :is_limiting

      t.timestamps
    end
  end
end
