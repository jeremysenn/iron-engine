class AddASeriesLoadingMethodToPrograms < ActiveRecord::Migration[8.1]
  def change
    add_column :programs, :a_series_loading_method, :string, default: nil
  end
end
