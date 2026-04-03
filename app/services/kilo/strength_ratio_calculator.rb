# Calculates strength ratios from PrimeEight E1RMs and identifies limiting lifts.
#
#   Input:  PrimeEightAssessment (with 4-8 PrimeEightLifts, Squat + Bench mandatory)
#   Output: RatioResult (ratios per lift, upper + lower limiting lifts, annotations)
#
#   Pipeline position: 2nd (after MAP assessment, before periodization engine)
#
#   E1RM calculation:
#     Reps 1-20  → KILO rep intensity table (KiloRepIntensityTable)
#     Reps > 20  → Epley formula: weight × (1 + 0.0333 × reps)
#
#   Limiting lift identification:
#     - One upper body, one lower body (always)
#     - Largest negative discrepancy from optimal ratio
#     - Ties broken by largest absolute E1RM
#     - When all ratios equal in a region → largest E1RM is "limiting" (balanced template)
#
class Kilo::StrengthRatioCalculator
  UPPER_BODY = %i[bench_press overhead_press incline_press dip chin_up].freeze
  LOWER_BODY = %i[squat front_squat deadlift].freeze
  UPPER_REFERENCE = :bench_press
  LOWER_REFERENCE = :squat

  class RatioResult < Kilo::Result
    attr_reader :ratios, :limiting_upper, :limiting_lower
  end

  class MissingBaselineError < StandardError; end
  class InsufficientDataError < StandardError; end
  class InvalidInputError < StandardError; end

  def call(assessment)
    lifts = assessment.prime_eight_lifts.index_by(&:exercise)

    validate_inputs!(lifts)
    calculate_e1rms!(lifts)

    ratios = compute_ratios(lifts)
    limiting_upper = find_limiting(ratios, UPPER_BODY)
    limiting_lower = find_limiting(ratios, LOWER_BODY)

    result = RatioResult.new(
      ratios: ratios,
      limiting_upper: limiting_upper,
      limiting_lower: limiting_lower
    )

    annotate_result!(result, ratios, limiting_upper, limiting_lower)
    result
  end

  private

  def validate_inputs!(lifts)
    unless lifts.key?("squat") || lifts.key?(:squat)
      raise MissingBaselineError, "Squat E1RM is required (lower body reference lift)"
    end

    unless lifts.key?("bench_press") || lifts.key?(:bench_press)
      raise MissingBaselineError, "Bench Press E1RM is required (upper body reference lift)"
    end

    if lifts.size < 4
      raise InsufficientDataError, "At least 4 of 8 PrimeEight lifts are required (got #{lifts.size})"
    end

    lifts.each_value do |lift|
      if lift.weight.to_f <= 0 || lift.reps.to_i <= 0
        raise InvalidInputError, "#{lift.exercise}: weight and reps must be positive"
      end
    end
  end

  def calculate_e1rms!(lifts)
    lifts.each_value do |lift|
      reps = lift.reps.to_i
      weight = lift.weight.to_f

      if reps <= 20
        intensity = KiloRepIntensityTable.lookup(reps)
        if intensity
          lift.e1rm = (weight / (intensity / 100.0)).round(1)
          lift.formula_used = :kilo_table
        else
          # Fallback if table row missing (shouldn't happen with proper seed data)
          lift.e1rm = epley(weight, reps)
          lift.formula_used = :epley
        end
      else
        lift.e1rm = epley(weight, reps)
        lift.formula_used = :epley
      end

      lift.save! if lift.persisted?
    end
  end

  def epley(weight, reps)
    (weight * (1 + 0.0333 * reps)).round(1)
  end

  def compute_ratios(lifts)
    squat_e1rm = find_lift(lifts, :squat).e1rm.to_f
    bench_e1rm = find_lift(lifts, :bench_press).e1rm.to_f

    ratios = {}

    lifts.each_value do |lift|
      exercise = lift.exercise.to_sym
      optimal = KiloOptimalRatio.find_by(exercise: exercise)
      next unless optimal

      reference_e1rm = UPPER_BODY.include?(exercise) ? bench_e1rm : squat_e1rm
      current_ratio = (lift.e1rm.to_f / reference_e1rm * 100).round(1)
      discrepancy = (current_ratio - optimal.ratio_pct).round(1)

      ratios[exercise] = {
        lift: lift,
        e1rm: lift.e1rm.to_f,
        current_ratio: current_ratio,
        optimal_ratio: optimal.ratio_pct.to_f,
        discrepancy: discrepancy,
        body_region: optimal.body_region
      }
    end

    ratios
  end

  def find_limiting(ratios, region_exercises)
    region = ratios.select { |ex, _| region_exercises.include?(ex) }
    return nil if region.empty?

    # Sort by discrepancy (ascending = most negative first), then by E1RM descending for ties
    region.min_by { |_, data| [ data[:discrepancy], -data[:e1rm] ] }&.first
  end

  def find_lift(lifts, exercise)
    lifts[exercise.to_s] || lifts[exercise]
  end

  def annotate_result!(result, ratios, limiting_upper, limiting_lower)
    ratios.each do |exercise, data|
      status = if data[:discrepancy] >= 0
        "At or above optimal"
      elsif data[:discrepancy] > -3
        "Close to optimal"
      else
        "Below optimal"
      end

      result.annotate(
        step: "ratio_calculation",
        rule: "Strength ratio for #{exercise}",
        value: "#{data[:current_ratio]}% (optimal: #{data[:optimal_ratio]}%, discrepancy: #{data[:discrepancy]}%)",
        decision: status
      )
    end

    if limiting_upper
      upper_data = ratios[limiting_upper]
      result.annotate(
        step: "limiting_lift_identification",
        rule: "Upper body limiting lift",
        value: "#{limiting_upper} at #{upper_data[:current_ratio]}% (optimal: #{upper_data[:optimal_ratio]}%)",
        decision: "Prioritize #{limiting_upper} in intensification phases"
      )
    end

    if limiting_lower
      lower_data = ratios[limiting_lower]
      result.annotate(
        step: "limiting_lift_identification",
        rule: "Lower body limiting lift",
        value: "#{limiting_lower} at #{lower_data[:current_ratio]}% (optimal: #{lower_data[:optimal_ratio]}%)",
        decision: "Prioritize #{limiting_lower} in intensification phases"
      )
    end
  end
end
