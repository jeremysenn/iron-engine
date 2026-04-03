class CreateMesocycles < ActiveRecord::Migration[8.1]
  def change
    create_table :mesocycles do |t|
      t.references :macrocycle, null: false, foreign_key: true
      t.integer :phase
      t.integer :number

      t.timestamps
    end
  end
end
