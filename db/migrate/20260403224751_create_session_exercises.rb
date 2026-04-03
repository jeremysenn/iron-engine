class CreateSessionExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :session_exercises do |t|
      t.references :training_session, null: false, foreign_key: true
      t.references :kilo_exercise, null: false, foreign_key: true
      t.string :position
      t.integer :sets
      t.string :tempo
      t.integer :rest_seconds

      t.timestamps
    end
  end
end
