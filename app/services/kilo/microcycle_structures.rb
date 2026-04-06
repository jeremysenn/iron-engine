# Microcycle structures define which session template is assigned to each
# training slot. The available structures depend on the training frequency.
#
# From the KILO Program Design Resource:
#   2x/week (Full Body): 2 structures rotating, each with FB1 + FB2
#   3x/week: 4 structures rotating, each session = one UB or LB type
#   4x/week (Upper/Lower): 2 structures, UB1/LB1/UB2/LB2
#
module Kilo::MicrocycleStructures
  UPPER_BODY_OPTIONS = %w[overhead_press incline_press bench_press dip].freeze
  LOWER_BODY_OPTIONS = %w[squat_1 squat_2 front_squat deadlift].freeze

  FULL_BODY_OPTIONS = %w[
    squat_1_overhead_press front_squat_incline_press
    squat_2_bench_press deadlift_dip
  ].freeze

  # 4x/week defaults (PD Resource p.8)
  DEFAULT_ACC_4X = {
    "upper_body_1" => "overhead_press",
    "lower_body_1" => "squat_1",
    "upper_body_2" => "bench_press",
    "lower_body_2" => "front_squat"
  }.freeze

  DEFAULT_INT_4X = {
    "upper_body_1" => "incline_press",
    "lower_body_1" => "squat_2",
    "upper_body_2" => "dip",
    "lower_body_2" => "deadlift"
  }.freeze

  # 2x/week defaults (PD Resource p.11)
  DEFAULT_ACC_2X = {
    "full_body_1" => "squat_1_overhead_press",
    "full_body_2" => "front_squat_incline_press"
  }.freeze

  DEFAULT_INT_2X = {
    "full_body_1" => "squat_2_bench_press",
    "full_body_2" => "deadlift_dip"
  }.freeze

  # 3x/week defaults - same session types as 4x but 3 sessions per week
  # Structure 1 (same UB+LB pair all 3 sessions)
  DEFAULT_ACC_3X = {
    "session_1" => "overhead_press",
    "session_2" => "squat_1",
    "session_3" => "overhead_press"
  }.freeze

  DEFAULT_INT_3X = {
    "session_1" => "incline_press",
    "session_2" => "front_squat",
    "session_3" => "incline_press"
  }.freeze

  # Aliases for backward compatibility
  DEFAULT_ACC = DEFAULT_ACC_4X
  DEFAULT_INT = DEFAULT_INT_4X

  def self.from_params(params)
    return nil unless params.is_a?(Hash) || params.is_a?(ActionController::Parameters)
    params.to_unsafe_h.stringify_keys
  end

  def self.defaults_for(phase, frequency = 4)
    is_acc = !phase.to_s.include?("intensification")
    case frequency.to_i
    when 2
      is_acc ? DEFAULT_ACC_2X : DEFAULT_INT_2X
    when 3
      is_acc ? DEFAULT_ACC_3X : DEFAULT_INT_3X
    else
      is_acc ? DEFAULT_ACC_4X : DEFAULT_INT_4X
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

  # Keep backward compat
  def self.upper_body_label(key) = label_for(key)
  def self.lower_body_label(key) = label_for(key)
end
