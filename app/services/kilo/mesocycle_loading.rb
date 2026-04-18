# Adjusts primary exercise weekly set counts based on the mesocycle's loading strategy.
#
# Only applies when:
#   - The mesocycle is exactly 3 weeks
#   - The primary exercises use Standard Sets (a_reps is an Integer)
#   - The exercise is marked as primary (A-series + B-series in Full Body)
#
# Returns the base_sets unchanged when conditions are not met.
#
class Kilo::MesocycleLoading
  # Offset patterns for each loading strategy across a 3-week mesocycle.
  # Key = strategy symbol, Value = [week1_offset, week2_offset, week3_offset]
  PATTERNS = {
    constant:      [ 0, 0, 0 ],
    ascending:     [ -1, 0, +1 ],
    descending:    [ +1, 0, -1 ],
    step:          [ 0, +1, -1 ],
    peaking:       [ +2, 0, -2 ],
    concentrated:  [ +1, +1, -1 ]
  }.freeze

  # Returns the adjusted set count for a given week within a mesocycle.
  #
  # @param base_sets [Integer] the A-series set count from the rep scheme (e.g., 5 from "5x5")
  # @param strategy [String, Symbol, nil] the loading strategy name
  # @param week_in_meso [Integer] 1-based week number within the mesocycle
  # @param total_weeks [Integer] total weeks in this mesocycle
  # @return [Integer] adjusted set count (minimum 1)
  def self.adjust_sets(base_sets:, strategy:, week_in_meso:, total_weeks:)
    return base_sets if total_weeks != 3
    return base_sets if strategy.blank? || strategy.to_sym == :constant

    offsets = PATTERNS[strategy.to_sym]
    return base_sets unless offsets

    offset = offsets[week_in_meso - 1]
    return base_sets unless offset

    [ base_sets + offset, 1 ].max
  end
end
