require "test_helper"

class Kilo::OsrSessionGeneratorTest < ActiveSupport::TestCase
  # Regression: OSR session exercises must carry primary_exercise on A-series
  # slots. Without it every OSR exercise persisted primary_exercise: false, so
  # Kilo::LoadingSchemeCalculator (which gates step loading on primary_exercise?)
  # always fell back to constant loading — A-series targets came out flat even
  # when the program's resolved loading method was "step".
  setup do
    @generator = Kilo::OsrSessionGenerator.new(training_level: :advanced)
  end

  def a_series_exercises(sessions)
    sessions.flat_map { |s| s[:exercises] }.select { |ex| ex[:position].to_s.start_with?("A") }
  end

  def non_a_exercises(sessions)
    sessions.flat_map { |s| s[:exercises] }.reject { |ex| ex[:position].to_s.start_with?("A") }
  end

  test "template-mode (Acc1) marks A-series exercises as primary" do
    result = @generator.call(
      phase: :accumulation,
      seed_phase: :accumulation,
      upper_sessions: [ "overhead_press" ],
      lower_sessions: [ "squat" ],
      limiting_lift_upper: :overhead_press,
      limiting_lift_lower: :squat,
      rep_scheme: "5x7",
      frequency: 4
    )

    a_series = a_series_exercises(result.sessions)
    assert a_series.any?, "expected at least one A-series exercise"
    assert a_series.all? { |ex| ex[:primary_exercise] == true },
      "all A-series exercises should be primary, got: #{a_series.map { |e| [ e[:position], e[:primary_exercise] ] }.inspect}"
    assert non_a_exercises(result.sessions).all? { |ex| ex[:primary_exercise] == false },
      "non-A exercises should not be primary"
  end

  test "example-mode (Int1) marks A-series exercises as primary" do
    result = @generator.call(
      phase: :intensification,
      seed_phase: :intensification,
      upper_sessions: [ "overhead_press" ],
      lower_sessions: [ "squat" ],
      limiting_lift_upper: :overhead_press,
      limiting_lift_lower: :squat,
      rep_scheme: "5x5",
      frequency: 4
    )

    a_series = a_series_exercises(result.sessions)
    assert a_series.any?, "expected at least one A-series exercise"
    assert a_series.all? { |ex| ex[:primary_exercise] == true },
      "all A-series exercises should be primary, got: #{a_series.map { |e| [ e[:position], e[:primary_exercise] ] }.inspect}"
    assert non_a_exercises(result.sessions).all? { |ex| ex[:primary_exercise] == false },
      "non-A exercises should not be primary"
  end
end
