class AddVideoUrlToKiloExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :kilo_exercises, :video_url, :string
  end
end
