class KiloExercise < ApplicationRecord
  has_many :session_exercises, dependent: :restrict_with_error
  has_many :primary_pairings, class_name: "KiloExercisePairing", foreign_key: :primary_exercise_id
  has_many :paired_pairings, class_name: "KiloExercisePairing", foreign_key: :paired_exercise_id

  enum :rotation_group, { press_oh_flat: 0, press_incline_dip: 1, pull_vertical: 2, pull_horizontal: 3 }

  validates :name, presence: true, uniqueness: true
end
