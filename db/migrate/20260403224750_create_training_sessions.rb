class CreateTrainingSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :training_sessions do |t|
      t.references :microcycle, null: false, foreign_key: true
      t.integer :day
      t.integer :session_type

      t.timestamps
    end
  end
end
