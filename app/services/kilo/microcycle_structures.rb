# Microcycle structures define which session template is assigned to each
# training slot within a weekly microcycle.
#
# For 4x/week (Upper/Lower split):
#   4 slots: UB1, LB1, UB2, LB2
#   Each slot independently selectable from the 8 session types
#
# For 3x/week (Upper/Lower/Upper or Lower/Upper/Lower):
#   3 slots per week, rotating through 4 microcycle structures
#
# Defaults from Program Design Resource p.8:
#   Accumulation:     UB1=Overhead Press, LB1=Squat 1, UB2=Bench Press, LB2=Front Squat
#   Intensification:  UB1=Incline Press, LB1=Squat 2, UB2=Dip, LB2=Deadlift
#
module Kilo::MicrocycleStructures
  UPPER_BODY_OPTIONS = %w[overhead_press incline_press bench_press dip].freeze
  LOWER_BODY_OPTIONS = %w[squat_1 squat_2 front_squat deadlift].freeze

  DEFAULT_ACC = {
    "upper_body_1" => "overhead_press",
    "lower_body_1" => "squat_1",
    "upper_body_2" => "bench_press",
    "lower_body_2" => "front_squat"
  }.freeze

  DEFAULT_INT = {
    "upper_body_1" => "incline_press",
    "lower_body_1" => "squat_2",
    "upper_body_2" => "dip",
    "lower_body_2" => "deadlift"
  }.freeze

  # Build a structure hash from per-slot params
  # @param params [Hash] { "upper_body_1" => "overhead_press", "lower_body_1" => "squat_1", ... }
  def self.from_params(params)
    return DEFAULT_ACC unless params.is_a?(Hash)
    params.to_h.stringify_keys
  end

  def self.defaults_for(phase)
    phase.to_s.include?("intensification") ? DEFAULT_INT : DEFAULT_ACC
  end

  def self.upper_body_label(key)
    { "overhead_press" => "Overhead Press", "incline_press" => "Incline Press",
      "bench_press" => "Bench Press", "dip" => "Dip" }[key.to_s] || key.to_s.titleize
  end

  def self.lower_body_label(key)
    { "squat_1" => "Squat 1", "squat_2" => "Squat 2",
      "front_squat" => "Front Squat", "deadlift" => "Deadlift" }[key.to_s] || key.to_s.titleize
  end
end
