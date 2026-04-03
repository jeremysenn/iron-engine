class KiloRepScheme < ApplicationRecord
  validates :total_reps, presence: true
  validates :rep_pattern, presence: true
end
