# Selects the correct periodization model based on training level and volume tolerance.
#
#   Input:  training_level (novice/intermediate/advanced), volume (low/medium/high)
#   Output: ModelResult (model_id like "2.2", rep schemes for 16 macrocycles)
#
#   Pipeline position: 3rd (after ratio calculator, before macrocycle builder)
#
#   Model numbering:
#     First digit = training level (1=Novice, 2=Intermediate, 3=Advanced)
#     Second digit = volume (1=Low, 2=Medium, 3=High)
#     e.g., Model 2.2 = Intermediate Medium Volume
#
class Kilo::PeriodizationEngine
  MODEL_MAP = {
    ["novice", "low"] => "1.1",
    ["novice", "medium"] => "1.2",
    ["novice", "high"] => "1.3",
    ["intermediate", "low"] => "2.1",
    ["intermediate", "medium"] => "2.2",
    ["intermediate", "high"] => "2.3",
    ["advanced", "low"] => "3.1",
    ["advanced", "medium"] => "3.2",
    ["advanced", "high"] => "3.3"
  }.freeze

  class ModelResult < Kilo::Result
    attr_reader :model_id, :rep_schemes
  end

  class InvalidTrainingLevel < StandardError; end
  class InvalidVolumeTolerance < StandardError; end
  class SeedDataMissing < StandardError; end

  def call(training_level:, volume:)
    training_level = training_level.to_s
    volume = volume.to_s

    model_id = MODEL_MAP[[training_level, volume]]

    raise InvalidTrainingLevel, "Invalid training level: #{training_level}" unless %w[novice intermediate advanced].include?(training_level)
    raise InvalidVolumeTolerance, "Invalid volume tolerance: #{volume}" unless %w[low medium high].include?(volume)
    raise SeedDataMissing, "No periodization model found for #{training_level}/#{volume}" unless model_id

    rep_schemes = KiloPeriodizationModel.where(model_id: model_id).order(:macrocycle_number, :phase)

    if rep_schemes.empty?
      raise SeedDataMissing, "No rep scheme data seeded for model #{model_id}. Run rake seed:from_csv."
    end

    result = ModelResult.new(model_id: model_id, rep_schemes: rep_schemes)

    result.annotate(
      step: "periodization_model_selection",
      rule: "Training level + volume → model",
      value: "#{training_level} + #{volume} = Model #{model_id}",
      decision: "Selected Model #{model_id} with #{rep_schemes.count} phase entries"
    )

    result
  end
end
