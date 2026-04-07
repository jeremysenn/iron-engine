class AddNameToKiloTrainingSplits < ActiveRecord::Migration[8.1]
  def change
    add_column :kilo_training_splits, :name, :string
  end
end
