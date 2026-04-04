class MapAssessment < ApplicationRecord
  belongs_to :client

  has_many :map_progressions, dependent: :destroy

  validates :assessed_at, presence: true

  def complete?
    map_progressions.count >= 15
  end
end
