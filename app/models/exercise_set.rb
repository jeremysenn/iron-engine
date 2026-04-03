class ExerciseSet < ApplicationRecord
  belongs_to :session_exercise

  validates :set_number, presence: true, numericality: { greater_than: 0 }
  validates :target_reps, presence: true, numericality: { greater_than: 0 }
end
