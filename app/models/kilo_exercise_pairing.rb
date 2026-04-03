class KiloExercisePairing < ApplicationRecord
  belongs_to :primary_exercise, class_name: "KiloExercise"
  belongs_to :paired_exercise, class_name: "KiloExercise"

  enum :context, { microcycle: 0, session: 1 }

  validates :context, presence: true
end
