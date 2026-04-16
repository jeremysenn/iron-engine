class AddSplitTypeToPrograms < ActiveRecord::Migration[8.0]
  def change
    add_column :programs, :split_type, :string
  end
end
