class PrimeEightLift < ApplicationRecord
  belongs_to :prime_eight_assessment

  has_one :strength_ratio_analysis, dependent: :destroy

  enum :exercise, {
    squat: 0, front_squat: 1, deadlift: 2,
    bench_press: 3, overhead_press: 4, incline_press: 5, dip: 6, chin_up: 7
  }

  enum :formula_used, { kilo_table: 0, epley: 1 }

  validates :exercise, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :reps, presence: true, numericality: { greater_than: 0 }
  validates :e1rm, presence: true, numericality: { greater_than: 0 }
end
