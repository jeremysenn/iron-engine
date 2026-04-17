class ExerciseSet < ApplicationRecord
  belongs_to :session_exercise

  validates :set_number, presence: true, numericality: { greater_than: 0 }
  validates :target_reps, presence: true, numericality: { greater_than: 0 }

  def prescribed_tonnage
    weight = target_weight.to_f
    return 0 if weight.zero?
    target_reps.to_i * weight
  end

  def actual_tonnage
    weight = actual_weight.to_f
    reps = actual_reps.to_i
    return 0 if weight.zero? || reps.zero?
    reps * weight
  end
end
