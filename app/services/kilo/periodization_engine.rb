# Selects the correct periodization model based on training level and volume tolerance.
#
#   Input:  goal, training_level, volume
#   Output: ModelResult (model_id like "1.1", rep schemes for all macrocycles)
#
#   Pipeline position: 3rd (after ratio calculator, before macrocycle builder)
#
#   Model numbering (from Long-Term Periodization Database):
#     First digit = training level (1=Novice, 2=Intermediate, 3=Advanced)
#     Second digit = volume tolerance (1=Low, 2=Medium, 3=High)
#     e.g., Model 2.2 = Intermediate Medium Volume
#
#   The model determines rep schemes for ALL 16 macrocycles across 4 years.
#   The goal determines which macrocycle SEQUENCE to follow (from Periodization Resource).
#   The current macrocycle number determines which rep schemes to use.
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

  VALID_GOALS = %w[hypertrophy absolute_strength relative_strength power].freeze
  VALID_LEVELS = %w[novice intermediate advanced].freeze
  VALID_VOLUMES = %w[low medium high].freeze

  class ModelResult < Kilo::Result
    attr_reader :model_id, :rep_schemes, :volume, :goal, :macrocycle_number
  end

  class InvalidTrainingLevel < StandardError; end
  class InvalidVolumeTolerance < StandardError; end
  class InvalidGoal < StandardError; end
  class SeedDataMissing < StandardError; end

  def call(goal:, training_level:, volume:, macrocycle_number: 1)
    goal = goal.to_s
    training_level = training_level.to_s
    volume = volume.to_s

    raise InvalidGoal, "Invalid goal: #{goal}" unless VALID_GOALS.include?(goal)
    raise InvalidTrainingLevel, "Invalid training level: #{training_level}" unless VALID_LEVELS.include?(training_level)
    raise InvalidVolumeTolerance, "Invalid volume tolerance: #{volume}" unless VALID_VOLUMES.include?(volume)

    model_id = MODEL_MAP[[training_level, volume]]

    rep_schemes = KiloPeriodizationModel.where(
      model_id: model_id,
      macrocycle_number: macrocycle_number
    ).order(:phase)

    if rep_schemes.empty?
      raise SeedDataMissing, "No rep scheme data seeded for model #{model_id}, macrocycle #{macrocycle_number}. Run rake seed:from_csv."
    end

    result = ModelResult.new(
      model_id: model_id,
      rep_schemes: rep_schemes,
      volume: volume,
      goal: goal,
      macrocycle_number: macrocycle_number
    )

    result.annotate(
      step: "periodization_model_selection",
      rule: "Training level + volume → periodization model",
      value: "#{training_level.capitalize} + #{volume} volume = Model #{model_id}, Macrocycle #{macrocycle_number}",
      decision: "Selected Model #{model_id} with #{rep_schemes.count} phase entries for #{goal.titleize} goal"
    )

    result
  end
end
