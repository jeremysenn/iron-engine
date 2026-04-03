class CreateKiloExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_exercises do |t|
      t.string :name
      t.string :category
      t.string :equipment
      t.string :grip_type
      t.string :grip_width
      t.integer :progression_order
      t.integer :rotation_group

      t.timestamps
    end
  end
end
