class Macrocycle < ApplicationRecord
  belongs_to :program

  has_many :mesocycles, dependent: :destroy

  validates :number, presence: true, numericality: { in: 1..4 }

  def prescribed_tonnage
    mesocycles.sum(&:prescribed_tonnage)
  end

  def actual_tonnage
    mesocycles.sum(&:actual_tonnage)
  end
end
