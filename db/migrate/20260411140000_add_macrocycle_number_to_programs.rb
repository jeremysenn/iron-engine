class AddMacrocycleNumberToPrograms < ActiveRecord::Migration[8.0]
  def change
    add_column :programs, :macrocycle_number, :integer, default: 1, null: false
  end
end
