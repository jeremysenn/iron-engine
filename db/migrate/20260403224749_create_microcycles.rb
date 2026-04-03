class CreateMicrocycles < ActiveRecord::Migration[8.1]
  def change
    create_table :microcycles do |t|
      t.references :mesocycle, null: false, foreign_key: true
      t.integer :week_number

      t.timestamps
    end
  end
end
