class TrainingSession < ApplicationRecord
  belongs_to :microcycle

  has_many :session_exercises, dependent: :destroy

  enum :session_type, {
    upper_body_1: 0, upper_body_2: 1,
    lower_body_1: 2, lower_body_2: 3,
    full_body: 4
  }

  validates :day, presence: true
  validates :session_type, presence: true
end
