class CreateMapAssessments < ActiveRecord::Migration[8.1]
  def change
    create_table :map_assessments do |t|
      t.references :client, null: false, foreign_key: true
      t.datetime :assessed_at
      t.text :notes

      t.timestamps
    end
  end
end
