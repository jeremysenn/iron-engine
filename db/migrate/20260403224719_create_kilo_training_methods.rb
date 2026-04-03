class CreateKiloTrainingMethods < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_training_methods do |t|
      t.string :name
      t.integer :category
      t.string :tempo
      t.text :description

      t.timestamps
    end
  end
end
