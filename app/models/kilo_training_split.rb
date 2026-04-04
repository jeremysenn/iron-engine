class KiloTrainingSplit < ApplicationRecord
  enum :goal, { hypertrophy: 0, absolute_strength: 1, relative_strength: 2, power: 3 }
  enum :phase, { accumulation: 0, intensification: 1 }
  enum :training_level, { novice: 0, intermediate: 1, advanced: 2 }

  validates :goal, presence: true
  validates :phase, presence: true
  validates :training_level, presence: true
  validates :frequency, presence: true, inclusion: { in: 2..6 }
end
