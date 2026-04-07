# Selects the training split for a given goal, phase, training level, and frequency.
#
#   Input:  goal, phase, training_level, frequency
#   Output: SplitBlueprint (split structure JSON defining session types per day)
#
#   Pipeline position: 5th (after macrocycle builder, before method timer)
#
#   Example split_structure for 4x/week upper/lower:
#     { "mon": "upper_body_1", "tue": "lower_body_1",
#       "thu": "upper_body_2", "fri": "lower_body_2" }
#
class Kilo::TrainingSplitSelector
  class SplitBlueprint < Kilo::Result
    attr_reader :split_structure, :frequency
  end

  class SplitNotFound < StandardError; end

  def call(goal:, phase:, training_level:, frequency:)
    split = KiloTrainingSplit.find_by(
      goal: goal,
      phase: phase,
      training_level: training_level,
      frequency: frequency
    )

    unless split
      raise SplitNotFound, "No training split found for #{goal}/#{phase}/#{training_level}/#{frequency}x per week"
    end

    struct = split.split_structure
    struct = JSON.parse(struct) if struct.is_a?(String)

    result = SplitBlueprint.new(
      split_structure: struct,
      frequency: frequency
    )

    result.annotate(
      step: "training_split_selection",
      rule: "Goal + phase + level + frequency → split",
      value: "#{goal} / #{phase} / #{training_level} / #{frequency}x week",
      decision: "#{split.name}: #{struct.values.join(', ')}"
    )

    result
  end
end
