class StrengthRatioAnalysis < ApplicationRecord
  belongs_to :prime_eight_lift

  validates :current_ratio, presence: true
  validates :optimal_ratio, presence: true
  validates :discrepancy, presence: true
end
