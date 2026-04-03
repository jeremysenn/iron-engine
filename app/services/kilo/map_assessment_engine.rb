# Evaluates MAP assessment results and determines exercise progressions.
#
#   Input:  MapAssessment (with 14 MapProgressions, one per movement pattern)
#   Output: MovementResult (movement levels per pattern, exercise progressions)
#
#   Pipeline position: 1st (feeds into session_generator for exercise selection)
#
#   Rules:
#     - MAP is all-or-nothing: all 14 patterns must be assessed
#     - Each pattern has levels 1-4, coach records pass/fail per level
#     - The highest passed level determines the exercise progression
#     - If incomplete (< 14 patterns), result is marked incomplete and
#       the engine uses default exercise progressions
#
class Kilo::MapAssessmentEngine
  REQUIRED_PATTERNS = 14

  class MovementResult < Kilo::Result
    attr_reader :levels, :complete
    alias_method :complete?, :complete
  end

  def call(assessment)
    progressions = assessment.map_progressions.order(:movement_pattern, level: :desc)
    levels = {}

    progressions.group_by(&:movement_pattern).each do |pattern, entries|
      highest_passed = entries.select(&:passed?).max_by(&:level)
      levels[pattern] = {
        level: highest_passed&.level || 0,
        exercise: highest_passed&.exercise_name,
        all_entries: entries.map { |e| { level: e.level, passed: e.passed? } }
      }
    end

    complete = levels.size >= REQUIRED_PATTERNS

    result = MovementResult.new(levels: levels, complete: complete)

    result.annotate(
      step: "map_assessment",
      rule: "MAP completeness check",
      value: "#{levels.size}/#{REQUIRED_PATTERNS} patterns assessed",
      decision: complete ? "MAP complete, exercise selection personalized" : "MAP incomplete, using default progressions"
    )

    levels.each do |pattern, data|
      result.annotate(
        step: "map_assessment",
        rule: "Movement level for #{pattern}",
        value: "Level #{data[:level]}",
        decision: data[:exercise] || "No progression (level 0)"
      )
    end

    result
  end
end
