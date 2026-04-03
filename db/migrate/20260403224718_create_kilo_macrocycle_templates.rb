class CreateKiloMacrocycleTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :kilo_macrocycle_templates do |t|
      t.string :limiting_lift_combo
      t.integer :phase
      t.jsonb :upper_sessions
      t.jsonb :lower_sessions

      t.timestamps
    end
  end
end
