class Microcycle < ApplicationRecord
  belongs_to :mesocycle

  has_many :training_sessions, dependent: :destroy

  validates :week_number, presence: true
end
