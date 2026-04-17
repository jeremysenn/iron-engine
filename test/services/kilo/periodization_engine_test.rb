require "test_helper"

class Kilo::PeriodizationEngineTest < ActiveSupport::TestCase
  setup do
    @engine = Kilo::PeriodizationEngine.new

    # Seed minimal periodization model (Model 2.2 = Intermediate Medium)
    KiloPeriodizationModel.create!(model_id: "2.2", macrocycle_number: 1, phase: :accumulation, rep_scheme: "5x7", intensity_pct: 70.0)
    KiloPeriodizationModel.create!(model_id: "2.2", macrocycle_number: 1, phase: :intensification, rep_scheme: "5x5", intensity_pct: 80.0)
  end

  test "selects correct model for intermediate medium volume" do
    result = @engine.call(goal: :hypertrophy, training_level: :intermediate, volume: :medium)

    assert_equal "2.2", result.model_id
    assert_equal 2, result.rep_schemes.count
  end

  test "all 9 model combinations map correctly" do
    expected = {
      [ "novice", "low" ] => "1.1",
      [ "novice", "medium" ] => "1.2",
      [ "novice", "high" ] => "1.3",
      [ "intermediate", "low" ] => "2.1",
      [ "intermediate", "medium" ] => "2.2",
      [ "intermediate", "high" ] => "2.3",
      [ "advanced", "low" ] => "3.1",
      [ "advanced", "medium" ] => "3.2",
      [ "advanced", "high" ] => "3.3"
    }

    expected.each do |(level, vol), model_id|
      KiloPeriodizationModel.find_or_create_by!(model_id: model_id, macrocycle_number: 1, phase: :accumulation) do |m|
        m.rep_scheme = "4x8"
        m.intensity_pct = 70.0
      end

      result = @engine.call(goal: :hypertrophy, training_level: level, volume: vol)
      assert_equal model_id, result.model_id, "Expected model #{model_id} for #{level}/#{vol}"
    end
  end

  test "raises InvalidTrainingLevel for bad input" do
    assert_raises(Kilo::PeriodizationEngine::InvalidTrainingLevel) do
      @engine.call(goal: :hypertrophy, training_level: "elite", volume: :medium)
    end
  end

  test "raises InvalidVolumeTolerance for bad input" do
    assert_raises(Kilo::PeriodizationEngine::InvalidVolumeTolerance) do
      @engine.call(goal: :hypertrophy, training_level: :intermediate, volume: "extreme")
    end
  end

  test "generates annotations with goal info" do
    result = @engine.call(goal: :hypertrophy, training_level: :intermediate, volume: :medium)

    assert result.annotations.any?
    annotation = result.annotations.first
    assert_equal "periodization_model_selection", annotation[:step]
    assert_includes annotation[:value], "2.2"
    assert_includes annotation[:decision], "Hypertrophy"
  end
end
