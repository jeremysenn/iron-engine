class AddCompletedAtToTrainingSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :training_sessions, :completed_at, :date
  end
end
