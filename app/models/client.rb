class Client < ApplicationRecord
  belongs_to :user

  has_many :map_assessments, dependent: :destroy
  has_many :prime_eight_assessments, dependent: :destroy
  has_many :programs, dependent: :destroy
  has_many :share_tokens, class_name: "ClientShareToken", dependent: :destroy

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

  def active_share_token
    share_tokens.active.order(created_at: :desc).first
  end

  def generate_share_token!(expires_in: 90.days)
    share_tokens.create!(expires_at: expires_in.from_now)
  end

  def tonnage_over_time
    TrainingSession
      .joins(microcycle: { mesocycle: { macrocycle: :program } })
      .joins(session_exercises: :exercise_sets)
      .where(programs: { client_id: id })
      .where.not(training_sessions: { completed_at: nil })
      .where("exercise_sets.actual_weight > 0 AND exercise_sets.actual_reps > 0")
      .group("training_sessions.id", "training_sessions.completed_at")
      .order("training_sessions.completed_at")
      .pluck(
        Arel.sql("training_sessions.completed_at"),
        Arel.sql("SUM(exercise_sets.actual_reps * exercise_sets.actual_weight)")
      )
  end
end
