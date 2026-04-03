class CreatePrimeEightAssessments < ActiveRecord::Migration[8.1]
  def change
    create_table :prime_eight_assessments do |t|
      t.references :client, null: false, foreign_key: true
      t.datetime :assessed_at

      t.timestamps
    end
  end
end
