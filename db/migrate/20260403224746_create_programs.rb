class CreatePrograms < ActiveRecord::Migration[8.1]
  def change
    create_table :programs do |t|
      t.references :client, null: false, foreign_key: true
      t.integer :goal
      t.integer :training_level
      t.integer :volume
      t.integer :frequency
      t.integer :limiting_lift_upper
      t.integer :limiting_lift_lower
      t.string :periodization_model
      t.integer :status
      t.datetime :archived_at
      t.jsonb :generation_metadata

      t.timestamps
    end

    add_index :programs, :client_id, unique: true, where: "status = 0", name: "index_programs_one_active_per_client"
  end
end
