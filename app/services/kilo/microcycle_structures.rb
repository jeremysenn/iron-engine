# Microcycle structures define which session template is assigned to each
# training slot. The PD Resource prescribes alternating microcycles:
#
#   4x/week: 2 microcycles alternating (Micro 1 / Micro 2)
#   3x/week: 4 microcycles rotating   (Micro 1 / 2 / 3 / 4)
#   2x/week: 2 microcycles alternating (Micro 1 / Micro 2)
#
module Kilo::MicrocycleStructures
  UPPER_BODY_OPTIONS = %w[overhead_press incline_press bench_press dip].freeze
  LOWER_BODY_OPTIONS = %w[squat_1 squat_2 front_squat deadlift].freeze

  FULL_BODY_OPTIONS = %w[
    squat_1_overhead_press front_squat_incline_press
    squat_2_bench_press deadlift_dip
  ].freeze

  # --- 4x/week: 2 alternating microcycles (PD Resource p.8) ---
  MICRO_1_4X = {
    "upper_body_1" => "overhead_press",
    "lower_body_1" => "squat_1",
    "upper_body_2" => "bench_press",
    "lower_body_2" => "front_squat"
  }.freeze

  MICRO_2_4X = {
    "upper_body_1" => "incline_press",
    "lower_body_1" => "squat_2",
    "upper_body_2" => "dip",
    "lower_body_2" => "deadlift"
  }.freeze

  # --- 3x/week: 4 rotating microcycles (PD Resource) ---
  MICRO_1_3X = {
    "session_1" => "overhead_press",
    "session_2" => "squat_1",
    "session_3" => "overhead_press"
  }.freeze

  MICRO_2_3X = {
    "session_1" => "incline_press",
    "session_2" => "front_squat",
    "session_3" => "incline_press"
  }.freeze

  MICRO_3_3X = {
    "session_1" => "bench_press",
    "session_2" => "squat_2",
    "session_3" => "bench_press"
  }.freeze

  MICRO_4_3X = {
    "session_1" => "dip",
    "session_2" => "deadlift",
    "session_3" => "dip"
  }.freeze

  # --- 2x/week: 2 alternating full-body microcycles (PD Resource p.11) ---
  MICRO_1_2X = {
    "full_body_1" => "squat_1_overhead_press",
    "full_body_2" => "front_squat_incline_press"
  }.freeze

  MICRO_2_2X = {
    "full_body_1" => "squat_2_bench_press",
    "full_body_2" => "deadlift_dip"
  }.freeze

  # Backward-compatible aliases
  DEFAULT_ACC_4X = MICRO_1_4X
  DEFAULT_INT_4X = MICRO_2_4X
  DEFAULT_ACC_2X = MICRO_1_2X
  DEFAULT_INT_2X = MICRO_2_2X
  DEFAULT_ACC_3X = MICRO_1_3X
  DEFAULT_INT_3X = MICRO_2_3X
  DEFAULT_ACC = MICRO_1_4X
  DEFAULT_INT = MICRO_2_4X

  # Returns the correct microcycle structure for the given week number.
  # Week numbers are 1-based. Alternation cycles:
  #   4x → 2 microcycles (odd weeks = Micro 1, even = Micro 2)
  #   3x → 4 microcycles (week 1→M1, week 2→M2, week 3→M3, week 4→M4, week 5→M1, …)
  #   2x → 2 microcycles (odd weeks = Micro 1, even = Micro 2)
  def self.for_week(frequency, week_number)
    case frequency.to_i
    when 2
      week_number.odd? ? MICRO_1_2X : MICRO_2_2X
    when 3
      [ MICRO_1_3X, MICRO_2_3X, MICRO_3_3X, MICRO_4_3X ][(week_number - 1) % 4]
    else # 4 or 5
      week_number.odd? ? MICRO_1_4X : MICRO_2_4X
    end
  end

  def self.from_params(params)
    return nil unless params.is_a?(Hash) || params.is_a?(ActionController::Parameters)
    params.to_unsafe_h.stringify_keys
  end

  def self.defaults_for(phase, frequency = 4, split_type: nil)
    is_acc = !phase.to_s.include?("intensification")
    case frequency.to_i
    when 2
      is_acc ? MICRO_1_2X : MICRO_2_2X
    when 3
      if split_type == "full_body"
        is_acc ? MICRO_1_3X_FB : MICRO_2_3X_FB
      else
        # 3x Upper/Lower uses the same 4x microcycle structure
        is_acc ? MICRO_1_4X : MICRO_2_4X
      end
    else
      is_acc ? MICRO_1_4X : MICRO_2_4X
    end
  end

  def self.label_for(key)
    labels = {
      "overhead_press" => "Overhead Press", "incline_press" => "Incline Press",
      "bench_press" => "Bench Press", "dip" => "Dip",
      "squat_1" => "Squat 1", "squat_2" => "Squat 2",
      "front_squat" => "Front Squat", "deadlift" => "Deadlift",
      "squat_1_overhead_press" => "Squat 1 & OH Press",
      "front_squat_incline_press" => "Front Squat & Incline Press",
      "squat_2_bench_press" => "Squat 2 & Bench Press",
      "deadlift_dip" => "Deadlift & Dip"
    }
    labels[key.to_s] || key.to_s.titleize
  end

  # 3x/week Upper/Lower rotation: the 4 workouts from the 4x split
  # cycle through 3 slots per week.
  #
  #   Week 1: UB1, LB1, UB2
  #   Week 2: LB2, UB1, LB1
  #   Week 3: UB2, LB2, UB1
  #   Week 4: LB1, UB2, LB2  (repeats)
  #
  DAYS_3X = %w[mon wed fri].freeze

  def self.three_day_upper_lower_split(week_number)
    sequence = %w[upper_body_1 lower_body_1 upper_body_2 lower_body_2]
    start = ((week_number - 1) * 3) % 4
    sessions = (0..2).map { |i| sequence[(start + i) % 4] }
    DAYS_3X.zip(sessions).to_h
  end

  # 3x/week Full Body split (PD Resource p.14):
  # 2 microcycles alternating, 3 full body sessions per week.
  MICRO_1_3X_FB = {
    "full_body_1" => "squat_1_overhead_press",
    "full_body_2" => "front_squat_incline_press",
    "full_body_3" => "squat_2_bench_press"
  }.freeze

  MICRO_2_3X_FB = {
    "full_body_1" => "deadlift_dip",
    "full_body_2" => "squat_1_overhead_press",
    "full_body_3" => "front_squat_incline_press"
  }.freeze

  def self.three_day_full_body_split
    { "mon" => "full_body_1", "wed" => "full_body_2", "fri" => "full_body_3" }
  end

  def self.upper_body_label(key) = label_for(key)
  def self.lower_body_label(key) = label_for(key)
end
