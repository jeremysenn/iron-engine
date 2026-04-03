class SessionExercise < ApplicationRecord
  belongs_to :training_session
  belongs_to :kilo_exercise

  has_many :exercise_sets, dependent: :destroy

  validates :position, presence: true
  validates :sets, presence: true, numericality: { greater_than: 0 }
  validates :rest_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
