class KiloOptimalRatio < ApplicationRecord
  # PrimeEight exercises
  enum :exercise, {
    squat: 0, front_squat: 1, deadlift: 2,
    bench_press: 3, overhead_press: 4, incline_press: 5, dip: 6, chin_up: 7
  }

  enum :body_region, { upper: 0, lower: 1 }

  validates :exercise, presence: true, uniqueness: true
  validates :body_region, presence: true
  validates :ratio_pct, presence: true, numericality: { greater_than: 0 }
end
