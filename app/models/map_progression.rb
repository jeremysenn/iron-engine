class MapProgression < ApplicationRecord
  belongs_to :map_assessment

  validates :movement_pattern, presence: true
  validates :level, presence: true, numericality: { in: 0..4 }
end
