class Program < ApplicationRecord
  belongs_to :client

  has_many :macrocycles, dependent: :destroy

  enum :goal, { hypertrophy: 0, absolute_strength: 1, relative_strength: 2, power: 3, balanced: 4, optimizing_strength_ratios: 5 }
  enum :training_level, { novice: 0, intermediate: 1, advanced: 2 }
  enum :volume, { low: 0, medium: 1, high: 2 }
  enum :status, { active: 0, archived: 1 }

  # PrimeEight exercise enums for limiting lifts
  enum :limiting_lift_upper, {
    upper_bench_press: 3, upper_overhead_press: 4, upper_incline_press: 5,
    upper_dip: 6, upper_chin_up: 7
  }, prefix: true

  enum :limiting_lift_lower, {
    lower_squat: 0, lower_front_squat: 1, lower_deadlift: 2
  }, prefix: true

  validates :goal, presence: true
  validates :training_level, presence: true
  validates :volume, presence: true
  validates :frequency, presence: true, inclusion: { in: 2..4 }
  validates :status, presence: true
  validates :macrocycle_number, presence: true, inclusion: { in: 1..16 }

  scope :with_full_structure, -> {
    includes(macrocycles: { mesocycles: { microcycles: { training_sessions: { session_exercises: [:exercise_sets, :kilo_exercise] } } } })
  }

  def archive!
    update!(status: :archived, archived_at: Time.current)
  end

  def map_applied?
    generation_metadata&.dig("map_applied") == true
  end
end
