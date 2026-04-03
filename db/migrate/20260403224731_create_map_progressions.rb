class CreateMapProgressions < ActiveRecord::Migration[8.1]
  def change
    create_table :map_progressions do |t|
      t.references :map_assessment, null: false, foreign_key: true
      t.string :movement_pattern
      t.integer :level
      t.boolean :passed
      t.string :exercise_name

      t.timestamps
    end
  end
end
