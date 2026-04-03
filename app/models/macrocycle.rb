class Macrocycle < ApplicationRecord
  belongs_to :program

  has_many :mesocycles, dependent: :destroy

  validates :number, presence: true, numericality: { in: 1..4 }
end
