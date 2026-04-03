class KiloRepIntensityTable < ApplicationRecord
  validates :reps, presence: true, uniqueness: true, numericality: { in: 1..20 }
  validates :intensity_pct, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  def self.lookup(reps)
    find_by(reps: reps)&.intensity_pct
  end
end
