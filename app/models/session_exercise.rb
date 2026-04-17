class SessionExercise < ApplicationRecord
  belongs_to :training_session
  belongs_to :kilo_exercise, optional: true

  has_many :exercise_sets, dependent: :destroy

  enum :group_type, { superset: 0, triset: 1, giant_set: 2, straight_set: 3, post_exhaustion: 4, heavy_light: 5 }

  validates :position, presence: true
  validates :sets, presence: true, numericality: { greater_than: 0 }
  validates :rest_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Store the exercise name directly so it works even without a kilo_exercise record
  # (coach-entered custom names, or template defaults that don't match the DB exactly)
  def exercise_name
    super.presence || kilo_exercise&.name || "—"
  end

  def prescribed_tonnage
    exercise_sets.sum(&:prescribed_tonnage)
  end

  def actual_tonnage
    exercise_sets.sum(&:actual_tonnage)
  end
end
