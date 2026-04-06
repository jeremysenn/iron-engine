# Microcycle structures define which PrimeEight exercises are assigned
# to each session slot within a weekly microcycle.
#
# From the KILO Program Design Resource (pages 8-10):
#
#   4x/week Training Split:
#     Mon: Upper Body 1 | Tue: Lower Body 1 | Thu: Upper Body 2 | Fri: Lower Body 2
#
#   Structure 1 (default accumulation):
#     UB1: Overhead Press | LB1: Squat 1 | UB2: Bench Press | LB2: Front Squat
#
#   Structure 2 (default intensification):
#     UB1: Incline Press | LB1: Squat 2 | UB2: Dip | LB2: Deadlift
#
module Kilo::MicrocycleStructures
  STRUCTURES = {
    "1" => {
      name: "Structure 1: OH Press / Squat 1 / Bench Press / Front Squat",
      upper_body_1: "overhead_press",
      lower_body_1: "squat_1",
      upper_body_2: "bench_press",
      lower_body_2: "front_squat"
    },
    "2" => {
      name: "Structure 2: Incline Press / Squat 2 / Dip / Deadlift",
      upper_body_1: "incline_press",
      lower_body_1: "squat_2",
      upper_body_2: "dip",
      lower_body_2: "deadlift"
    }
  }.freeze

  def self.for(key)
    STRUCTURES[key.to_s] || STRUCTURES["1"]
  end
end
