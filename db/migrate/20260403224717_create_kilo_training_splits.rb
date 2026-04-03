class CreateKiloTrainingSplits < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_training_splits do |t|
      t.integer :goal
      t.integer :phase
      t.integer :training_level
      t.integer :frequency
      t.jsonb :split_structure

      t.timestamps
    end
  end
end
