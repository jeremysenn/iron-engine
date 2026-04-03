class CreateMacrocycles < ActiveRecord::Migration[8.1]
  def change
    create_table :macrocycles do |t|
      t.references :program, null: false, foreign_key: true
      t.integer :number
      t.string :goal_focus

      t.timestamps
    end
  end
end
