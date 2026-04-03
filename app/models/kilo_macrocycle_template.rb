class KiloMacrocycleTemplate < ApplicationRecord
  enum :phase, { accumulation: 0, intensification: 1 }

  validates :limiting_lift_combo, presence: true
  validates :phase, presence: true
end
