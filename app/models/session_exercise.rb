class SessionExercise < ApplicationRecord
  belongs_to :training_session
  belongs_to :kilo_exercise, optional: true

  has_many :exercise_sets, dependent: :destroy

  validates :position, presence: true
  validates :sets, presence: true, numericality: { greater_than: 0 }
  validates :rest_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Store the exercise name directly so it works even without a kilo_exercise record
  # (coach-entered custom names, or template defaults that don't match the DB exactly)
  def exercise_name
    super.presence || kilo_exercise&.name || "—"
  end
end
