require "test_helper"

class Kilo::ProgramGeneratorTest < ActiveSupport::TestCase
  setup do
    seed_reference_data!

    @user = User.create!(email_address: "coach@test.com", password: "password123")
    @client = @user.clients.create!(first_name: "John", last_name: "Doe", training_age: :intermediate)
    @assessment = @client.prime_eight_assessments.create!(assessed_at: Time.current)

    # Create 4 lifts (minimum) with 1RM values
    { squat: 450, front_squat: 360, bench_press: 315, overhead_press: 205 }.each do |exercise, weight|
      @assessment.prime_eight_lifts.create!(
        exercise: exercise, weight: weight, reps: 1, e1rm: weight, formula_used: :kilo_table
      )
    end

    @generator = Kilo::ProgramGenerator.new
  end

  test "generates a complete program with full hierarchy" do
    program = @generator.call(
      client: @client,
      assessment: @assessment.reload,
      goal: "hypertrophy",
      volume: "medium",
      frequency: 4
    )

    assert program.persisted?
    assert_equal "active", program.status
    assert_equal "hypertrophy", program.goal
    assert_equal "intermediate", program.training_level
    assert_equal "medium", program.volume
    assert_equal 4, program.frequency
    assert_equal "2.2", program.periodization_model

    # Should have 1 macrocycle with 4 mesocycles
    assert_equal 1, program.macrocycles.count

    macrocycle = program.macrocycles.first
    assert_equal 4, macrocycle.mesocycles.count

    # Phase pattern: accumulation, intensification, accumulation, intensification
    phases = macrocycle.mesocycles.order(:number).pluck(:phase)
    assert_equal %w[accumulation intensification accumulation intensification], phases

    # Each mesocycle should have 3 microcycles (3 weeks)
    macrocycle.mesocycles.each do |meso|
      assert_equal 3, meso.microcycles.count
    end

    # Total weeks should be 12
    total_weeks = macrocycle.mesocycles.sum { |m| m.microcycles.count }
    assert_equal 12, total_weeks
  end

  test "archives existing active program on regeneration" do
    # Generate first program
    program1 = @generator.call(
      client: @client,
      assessment: @assessment.reload,
      goal: "hypertrophy",
      volume: "medium",
      frequency: 4
    )

    assert_equal "active", program1.status

    # Generate second program
    program2 = @generator.call(
      client: @client,
      assessment: @assessment.reload,
      goal: "absolute_strength",
      volume: "low",
      frequency: 3
    )

    program1.reload
    assert_equal "archived", program1.status
    assert_not_nil program1.archived_at
    assert_equal "active", program2.status
  end

  test "generation_metadata includes version and key decisions" do
    program = @generator.call(
      client: @client,
      assessment: @assessment.reload,
      goal: "hypertrophy",
      volume: "medium",
      frequency: 4
    )

    metadata = program.generation_metadata
    assert_equal 1, metadata["metadata_version"]
    assert_equal "2.2", metadata["model_id"]
    assert metadata["annotations"].is_a?(Array)
    assert metadata["annotations"].any?
    assert_not_nil metadata["generated_at"]
  end

  test "rescues seed data gaps gracefully" do
    # This should work even with minimal seed data because
    # the split selector falls back to default splits
    program = @generator.call(
      client: @client,
      assessment: @assessment.reload,
      goal: "power",
      volume: "high",
      frequency: 2
    )

    assert program.persisted?
    assert_equal "active", program.status
  end

  private

  def seed_reference_data!
    # Optimal ratios
    [
      { exercise: :squat, body_region: :lower, ratio_pct: 100.0 },
      { exercise: :front_squat, body_region: :lower, ratio_pct: 85.0 },
      { exercise: :deadlift, body_region: :lower, ratio_pct: 125.0 },
      { exercise: :bench_press, body_region: :upper, ratio_pct: 100.0 },
      { exercise: :overhead_press, body_region: :upper, ratio_pct: 72.0 },
      { exercise: :incline_press, body_region: :upper, ratio_pct: 91.0 },
      { exercise: :dip, body_region: :upper, ratio_pct: 117.0 },
      { exercise: :chin_up, body_region: :upper, ratio_pct: 87.0 }
    ].each { |a| KiloOptimalRatio.find_or_create_by!(a) }

    # Seed all 4 phases for each model needed by tests
    { "2.2" => { acc: ["5x7", 70.0], int: ["5x5", 80.0], acc2: ["4x10", 74.0], int2: ["6x4", 85.0] },
      "2.1" => { acc: ["4x10", 65.0], int: ["4x6", 82.0], acc2: ["5x9", 76.0], int2: ["5x4", 85.0] },
      "2.3" => { acc: ["4x8", 65.0], int: ["4x4", 85.0], acc2: ["5x7", 78.0], int2: ["6x3", 90.0] }
    }.each do |mid, phases|
      KiloPeriodizationModel.find_or_create_by!(model_id: mid, macrocycle_number: 1, phase: :accumulation) { |m| m.rep_scheme = phases[:acc][0]; m.intensity_pct = phases[:acc][1] }
      KiloPeriodizationModel.find_or_create_by!(model_id: mid, macrocycle_number: 1, phase: :intensification) { |m| m.rep_scheme = phases[:int][0]; m.intensity_pct = phases[:int][1] }
      KiloPeriodizationModel.find_or_create_by!(model_id: mid, macrocycle_number: 1, phase: :accumulation_2) { |m| m.rep_scheme = phases[:acc2][0]; m.intensity_pct = phases[:acc2][1] }
      KiloPeriodizationModel.find_or_create_by!(model_id: mid, macrocycle_number: 1, phase: :intensification_2) { |m| m.rep_scheme = phases[:int2][0]; m.intensity_pct = phases[:int2][1] }
    end

    # A few exercises so the session generator has something to work with
    %w[Squat Front\ Squat Deadlift Bench\ Press Overhead\ Press Incline\ Press].each_with_index do |name, i|
      category = i < 3 ? "lower" : "upper_press"
      KiloExercise.find_or_create_by!(name: name) do |e|
        e.category = category
        e.equipment = "barbell"
      end
    end
  end
end
