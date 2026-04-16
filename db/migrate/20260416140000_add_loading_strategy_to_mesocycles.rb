class AddLoadingStrategyToMesocycles < ActiveRecord::Migration[8.1]
  def change
    add_column :mesocycles, :loading_strategy, :string, default: nil
  end
end
