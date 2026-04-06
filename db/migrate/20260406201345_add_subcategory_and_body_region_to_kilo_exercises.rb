class AddSubcategoryAndBodyRegionToKiloExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :kilo_exercises, :body_region, :string
    add_column :kilo_exercises, :subcategory, :string
  end
end
