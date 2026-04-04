class KiloPeriodizationModel < ApplicationRecord
  enum :phase, { accumulation: 0, intensification: 1, accumulation_2: 2, intensification_2: 3 }

  validates :model_id, presence: true
  validates :macrocycle_number, presence: true, numericality: { in: 1..16 }
  validates :phase, presence: true
  validates :rep_scheme, presence: true
end
