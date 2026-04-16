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
    full_body_1: 21, full_body_2: 22, full_body_3: 27,
    chest_and_arms: 23, back_and_shoulders: 24, chest: 25, back: 26,
    overhead_press_variation: 28, squat_2_front_squat_a: 29
  }

  validates :day, presence: true
  validates :session_type, presence: true

  def template
    Kilo::SessionTemplates.for(session_type)
  end

  def template_name
    template&.dig(:name) || session_type.titleize
  end

  def logged?
    session_exercises.joins(:exercise_sets)
      .where("exercise_sets.actual_weight > 0")
      .exists?
  end

  def estimated_duration_seconds
    exercises = session_exercises.map do |se|
      {
        sets: se.sets,
        target_reps: se.exercise_sets.first&.target_reps.to_s,
        tempo: se.tempo,
        rest_seconds: se.rest_seconds
      }
    end
    Kilo::RestCalculator.estimate_duration(exercises)
  end

  def estimated_duration
    Kilo::RestCalculator.format_duration(estimated_duration_seconds)
  end
end
