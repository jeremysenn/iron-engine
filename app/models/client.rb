class Client < ApplicationRecord
  belongs_to :user

  has_many :map_assessments, dependent: :destroy
  has_many :prime_eight_assessments, dependent: :destroy
  has_many :programs, dependent: :destroy

  enum :training_age, { novice: 0, intermediate: 1, advanced: 2 }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :training_age, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def active_program
    programs.find_by(status: :active)
  end
end
