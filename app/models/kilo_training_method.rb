class KiloTrainingMethod < ApplicationRecord
  enum :category, { concentric: 0, eccentric: 1, isometric: 2 }

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
end
