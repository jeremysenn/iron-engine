class PrimeEightAssessment < ApplicationRecord
  belongs_to :client

  has_many :prime_eight_lifts, dependent: :destroy
  has_many :strength_ratio_analyses, through: :prime_eight_lifts

  validates :assessed_at, presence: true

  def squat_lift
    prime_eight_lifts.find_by(exercise: :squat)
  end

  def bench_lift
    prime_eight_lifts.find_by(exercise: :bench_press)
  end
end
