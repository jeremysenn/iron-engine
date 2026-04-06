class TrainingSession < ApplicationRecord
  belongs_to :microcycle

  has_many :session_exercises, dependent: :destroy

  enum :session_type, {
    upper_body_1: 0, upper_body_2: 1,
    lower_body_1: 2, lower_body_2: 3,
    full_body: 4,
    overhead_press: 5, incline_press: 6, bench_press: 7, dip: 8,
    squat_1: 9, squat_2: 10, front_squat: 11, deadlift: 12,
    arms_and_shoulders: 13, chest_and_back: 14, lower_body: 15, posterior_chain: 16,
    squat_1_overhead_press: 17, front_squat_incline_press: 18,
    squat_2_bench_press: 19, deadlift_dip: 20,
    full_body_1: 21, full_body_2: 22
  }

  validates :day, presence: true
  validates :session_type, presence: true

  def template
    Kilo::SessionTemplates.for(session_type)
  end

  def template_name
    template&.dig(:name) || session_type.titleize
  end
end
