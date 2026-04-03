class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.integer :training_age
      t.date :date_of_birth
      t.text :notes

      t.timestamps
    end
  end
end
