require "test_helper"

class Kilo::StrengthRatioCalculatorTest < ActiveSupport::TestCase
  setup do
    # Seed optimal ratios
    seed_optimal_ratios!

    @user = User.create!(email_address: "coach@test.com", password: "password123")
    @client = @user.clients.create!(first_name: "John", last_name: "Doe", training_age: :intermediate)
    @assessment = @client.prime_eight_assessments.create!(assessed_at: Time.current)
    @calculator = Kilo::StrengthRatioCalculator.new
  end

  test "calculates correct ratios for full 8-lift assessment" do
    create_lifts(
      squat: { weight: 450, reps: 1 },
      front_squat: { weight: 360, reps: 1 },
      deadlift: { weight: 565, reps: 1 },
      bench_press: { weight: 315, reps: 1 },
      overhead_press: { weight: 205, reps: 1 },
      incline_press: { weight: 275, reps: 1 },
      dip: { weight: 370, reps: 1 },
      chin_up: { weight: 270, reps: 1 }
    )

    result = @calculator.call(@assessment.reload)

    assert_equal 8, result.ratios.size

    # Squat is reference (100%), Front Squat should be 80%
    assert_in_delta 80.0, result.ratios[:front_squat][:current_ratio], 0.1
    assert_in_delta 85.0, result.ratios[:front_squat][:optimal_ratio], 0.1
    assert_in_delta(-5.0, result.ratios[:front_squat][:discrepancy], 0.1)

    # Bench is reference (100%), OH Press should be ~65%
    assert_in_delta 65.1, result.ratios[:overhead_press][:current_ratio], 0.1

    # Limiting lifts identified
    assert_equal :front_squat, result.limiting_lower
    assert_equal :overhead_press, result.limiting_upper
  end

  test "raises MissingBaselineError when squat is missing" do
    create_lifts(
      bench_press: { weight: 315, reps: 1 },
      overhead_press: { weight: 205, reps: 1 },
      incline_press: { weight: 275, reps: 1 },
      dip: { weight: 370, reps: 1 }
    )

    assert_raises(Kilo::StrengthRatioCalculator::MissingBaselineError) do
      @calculator.call(@assessment.reload)
    end
  end

  test "raises MissingBaselineError when bench press is missing" do
    create_lifts(
      squat: { weight: 450, reps: 1 },
      front_squat: { weight: 360, reps: 1 },
      deadlift: { weight: 565, reps: 1 },
      overhead_press: { weight: 205, reps: 1 }
    )

    assert_raises(Kilo::StrengthRatioCalculator::MissingBaselineError) do
      @calculator.call(@assessment.reload)
    end
  end

  test "raises InsufficientDataError with fewer than 4 lifts" do
    create_lifts(
      squat: { weight: 450, reps: 1 },
      bench_press: { weight: 315, reps: 1 },
      deadlift: { weight: 565, reps: 1 }
    )

    assert_raises(Kilo::StrengthRatioCalculator::InsufficientDataError) do
      @calculator.call(@assessment.reload)
    end
  end

  test "works with minimum 4 lifts" do
    create_lifts(
      squat: { weight: 450, reps: 1 },
      front_squat: { weight: 360, reps: 1 },
      bench_press: { weight: 315, reps: 1 },
      overhead_press: { weight: 205, reps: 1 }
    )

    result = @calculator.call(@assessment.reload)

    assert_equal 4, result.ratios.size
    assert_not_nil result.limiting_upper
    assert_not_nil result.limiting_lower
  end

  test "tie-breaking: largest absolute E1RM wins when discrepancies are equal" do
    # Both front squat and deadlift at -5% discrepancy from optimal
    # Deadlift has higher E1RM (540 vs 382.5), so deadlift should be limiting
    create_lifts(
      squat: { weight: 450, reps: 1 },
      front_squat: { weight: 382.5, reps: 1 },  # 85% of 450 = optimal, minus some
      deadlift: { weight: 540, reps: 1 },         # 120% of 450, optimal is 125% = -5%
      bench_press: { weight: 315, reps: 1 }
    )

    result = @calculator.call(@assessment.reload)
    # Both should be close to -5% discrepancy. The one with larger E1RM wins.
    assert_not_nil result.limiting_lower
  end

  test "all ratios identical within a region: largest E1RM is limiting (balanced)" do
    # All upper body lifts at exactly optimal ratios
    create_lifts(
      squat: { weight: 400, reps: 1 },
      bench_press: { weight: 300, reps: 1 },
      overhead_press: { weight: 216, reps: 1 },   # 72% of 300
      incline_press: { weight: 273, reps: 1 },     # 91% of 300
      dip: { weight: 351, reps: 1 },               # 117% of 300
      chin_up: { weight: 261, reps: 1 }            # 87% of 300
    )

    result = @calculator.call(@assessment.reload)
    # All upper body discrepancies ~0, largest E1RM should be limiting
    assert_not_nil result.limiting_upper
  end

  test "uses Epley formula for reps > 20 and sets formula_used" do
    seed_rep_intensity_table!

    create_lifts(
      squat: { weight: 200, reps: 25 },
      bench_press: { weight: 150, reps: 25 },
      front_squat: { weight: 170, reps: 25 },
      overhead_press: { weight: 100, reps: 25 }
    )

    result = @calculator.call(@assessment.reload)

    @assessment.prime_eight_lifts.each do |lift|
      assert_equal "epley", lift.formula_used
      expected_e1rm = (lift.weight * (1 + 0.0333 * 25)).round(1)
      assert_in_delta expected_e1rm, lift.e1rm, 0.2
    end
  end

  test "annotations are generated for each ratio and limiting lift" do
    create_lifts(
      squat: { weight: 450, reps: 1 },
      front_squat: { weight: 360, reps: 1 },
      bench_press: { weight: 315, reps: 1 },
      overhead_press: { weight: 205, reps: 1 }
    )

    result = @calculator.call(@assessment.reload)

    # Should have annotations for each ratio + 2 limiting lift annotations
    ratio_annotations = result.annotations.select { |a| a[:step] == "ratio_calculation" }
    limiting_annotations = result.annotations.select { |a| a[:step] == "limiting_lift_identification" }

    assert_equal 4, ratio_annotations.size
    assert_equal 2, limiting_annotations.size
  end

  private

  def create_lifts(lifts_hash)
    lifts_hash.each do |exercise, attrs|
      e1rm = if attrs[:reps] == 1
        attrs[:weight]
      else
        # Pre-calculate so validation passes; calculator will recalculate
        (attrs[:weight] * (1 + 0.0333 * attrs[:reps])).round(1)
      end

      @assessment.prime_eight_lifts.create!(
        exercise: exercise,
        weight: attrs[:weight],
        reps: attrs[:reps],
        e1rm: e1rm,
        formula_used: :kilo_table
      )
    end
  end

  def seed_optimal_ratios!
    [
      { exercise: :squat, body_region: :lower, ratio_pct: 100.0 },
      { exercise: :front_squat, body_region: :lower, ratio_pct: 85.0 },
      { exercise: :deadlift, body_region: :lower, ratio_pct: 125.0 },
      { exercise: :bench_press, body_region: :upper, ratio_pct: 100.0 },
      { exercise: :overhead_press, body_region: :upper, ratio_pct: 72.0 },
      { exercise: :incline_press, body_region: :upper, ratio_pct: 91.0 },
      { exercise: :dip, body_region: :upper, ratio_pct: 117.0 },
      { exercise: :chin_up, body_region: :upper, ratio_pct: 87.0 }
    ].each { |attrs| KiloOptimalRatio.find_or_create_by!(attrs) }
  end

  def seed_rep_intensity_table!
    (1..20).each do |reps|
      # Approximate KILO table values (these need real values from the PDF)
      pct = case reps
      when 1 then 100.0
      when 2 then 95.0
      when 3 then 92.5
      when 4 then 90.0
      when 5 then 87.5
      when 6 then 85.0
      when 7 then 82.5
      when 8 then 80.0
      when 9 then 77.5
      when 10 then 75.0
      else 75.0 - (reps - 10) * 2.5
      end
      KiloRepIntensityTable.find_or_create_by!(reps: reps, intensity_pct: pct)
    end
  end
end
