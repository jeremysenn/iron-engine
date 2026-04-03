class Mesocycle < ApplicationRecord
  belongs_to :macrocycle

  has_many :microcycles, dependent: :destroy

  enum :phase, { accumulation: 0, intensification: 1 }

  validates :phase, presence: true
  validates :number, presence: true
end
