class Microcycle < ApplicationRecord
  belongs_to :mesocycle

  has_many :training_sessions, dependent: :destroy

  validates :week_number, presence: true

  def prescribed_tonnage
    training_sessions.sum(&:prescribed_tonnage)
  end

  def actual_tonnage
    training_sessions.sum(&:actual_tonnage)
  end
end
