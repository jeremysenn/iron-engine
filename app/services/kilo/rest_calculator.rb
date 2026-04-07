# Calculates rest periods based on exercise position and training phase.
#
# From KILO methodology:
#   Accumulation phases (higher volume, lower intensity):
#     A series: 180 seconds
#     B1/B2 (superset): 75 seconds between exercises
#     B (single): 150 seconds
#     C1/C2: 60 seconds
#
#   Intensification phases (lower volume, higher intensity):
#     A series: 240 seconds
#     B1/B2 (superset): 90 seconds between exercises
#     B (single): 180 seconds
#     C1/C2: 60 seconds
#
#   D series (full body sessions): same as C series
#
module Kilo::RestCalculator
  ACCUMULATION = {
    "A"  => 180, "A1" => 180, "A2" => 180,
    "B"  => 150, "B1" => 75,  "B2" => 75,
    "C"  => 60,  "C1" => 60,  "C2" => 60,
    "D"  => 60,  "D1" => 60,  "D2" => 60
  }.freeze

  INTENSIFICATION = {
    "A"  => 240, "A1" => 240, "A2" => 240,
    "B"  => 180, "B1" => 90,  "B2" => 90,
    "C"  => 60,  "C1" => 60,  "C2" => 60,
    "D"  => 60,  "D1" => 60,  "D2" => 60
  }.freeze

  def self.for(position, phase: :accumulation, template_rest: nil)
    return template_rest if template_rest
    table = phase.to_s.include?("intensification") ? INTENSIFICATION : ACCUMULATION
    table[position.to_s] || 60
  end

  # Calculates estimated workout duration in seconds.
  #
  # For each exercise:
  #   time_per_rep = sum of tempo digits (X counts as 1)
  #   set_duration = reps × time_per_rep
  #   exercise_time = (sets × set_duration) + (sets × rest_seconds)
  #
  # Total = sum of all exercise times
  #
  def self.estimate_duration(exercises)
    total = 0

    exercises.each do |ex|
      sets = ex[:sets].to_i
      sets = 4 if sets == 0

      # Parse reps (take first number from ranges like "6-10" or "1-12")
      reps = ex[:target_reps].to_s.split(/[-,]/).first.to_i
      reps = 8 if reps == 0

      # Parse tempo: "4-0-X-0" => sum digits, X=1
      tempo_str = ex[:tempo].to_s
      seconds_per_rep = tempo_str.split("-").sum do |part|
        part.strip.upcase == "X" ? 1 : part.to_i
      end
      seconds_per_rep = 4 if seconds_per_rep == 0

      rest = ex[:rest_seconds].to_i

      # Time under tension for all sets
      set_time = reps * seconds_per_rep
      # Total: perform set + rest, for all sets (rest after last set = transition)
      exercise_time = (sets * set_time) + (sets * rest)

      total += exercise_time
    end

    total
  end

  def self.format_duration(seconds)
    minutes = seconds / 60
    "#{minutes} min"
  end
end
