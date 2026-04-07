# Defines the 8 KILO session templates from the Program Design Resource.
# Exercise names use the KILO Exercise Database naming convention.
#
# Coaches can override any exercise in any slot with any exercise from
# the KILO Exercise Database, a custom exercise they created, or a new entry.
#
module Kilo::SessionTemplates
  UPPER_BODY = {
    "overhead_press" => {
      name: "Overhead Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Close Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B1", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "triceps", default_exercise: "Triceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "biceps", default_exercise: "Biceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "incline_press" => {
      name: "Incline Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B1", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Supinating", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "triceps", default_exercise: "Triceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "biceps", default_exercise: "Biceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "bench_press" => {
      name: "Bench Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B1", category: "assistance_press", default_exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "scapular_retraction", default_exercise: "Scapular Retraction", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "dip" => {
      name: "Dip",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "A2", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B1", category: "assistance_press", default_exercise: "Press - 15° Incline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "scapular_retraction", default_exercise: "Scapular Retraction", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    }
  }.freeze

  LOWER_BODY = {
    "squat_1" => {
      name: "Squat 1",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "knee_extension", default_exercise: "Leg Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "hip_extension", default_exercise: "Back Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "squat_2" => {
      name: "Squat 2",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
        { position: "B", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "4-5", reps: "6-12", tempo: "3-0-1-0", rest: 180 },
        { position: "C1", category: "knee_extension", default_exercise: "Leg Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "hip_extension", default_exercise: "Back Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "front_squat" => {
      name: "Front Squat",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "4-6", reps: "1-6", tempo: "4-0-X-0", rest: 240 },
        { position: "B", category: "specialty_deadlift", default_exercise: "Deadlift - Rack - Mid Thigh - BB - Wide Grip", sets: "4-5", reps: "6-12", tempo: "3-0-1-0", rest: 180 },
        { position: "C1", category: "calves", default_exercise: "Calf Raise", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "abdominal", default_exercise: "Abs", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "deadlift" => {
      name: "Deadlift",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "4-6", reps: "1-6", tempo: "4-1-X-0", rest: 240 },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "calves", default_exercise: "Calf Raise", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "abdominal", default_exercise: "Abs", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    }
  }.freeze

  FULL_BODY = {
    "squat_1_overhead_press" => {
      name: "Squat 1 & Overhead Press",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
        { position: "B1", category: "primary_press", default_exercise: "Overhead Press", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Close Grip - Semi-Supinated", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "C1", category: "split_stance", default_exercise: "Split Squat", sets: "2-3", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "C2", category: "knee_flexion", default_exercise: "Leg Curl", sets: "2-3", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "D1", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 }
      ]
    },
    "front_squat_incline_press" => {
      name: "Front Squat & Incline Press",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "3-4", reps: "1-6", tempo: "4-0-X-0", rest: 240 },
        { position: "B1", category: "primary_press", default_exercise: "Incline Press", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "C", category: "specialty_deadlift", default_exercise: "Deadlift - Rack - Mid Thigh - BB - Wide Grip", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 180 },
        { position: "D1", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Pronated", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 }
      ]
    },
    "squat_2_bench_press" => {
      name: "Squat 2 & Bench Press",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
        { position: "B1", category: "primary_press", default_exercise: "Bench Press", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "C", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 180 },
        { position: "D1", category: "assistance_press", default_exercise: "Press - Seated - DB", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Supinating", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 }
      ]
    },
    "deadlift_dip" => {
      name: "Deadlift & Dip",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "3-4", reps: "1-6", tempo: "4-1-X-0", rest: 240 },
        { position: "B1", category: "primary_press", default_exercise: "Dip", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "B2", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
        { position: "C1", category: "split_stance", default_exercise: "Split Squat", sets: "2-3", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "C2", category: "knee_flexion", default_exercise: "Leg Curl", sets: "2-3", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "D1", category: "assistance_press", default_exercise: "Press - 15° Incline - DB", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "2-3", reps: "6-10", tempo: "3-0-1-0", rest: 60 }
      ]
    }
  }.freeze

  # Body part session templates from the KILO Training Split Database.
  #
  # These use grouped exercise structures (trisets, post-exhaustion, giant sets)
  # rather than the superset pairs used in upper/lower templates.
  #
  # Each slot includes group + group_type fields for exercise grouping.
  # Rest values are template-specific (passed to RestCalculator via template_rest:).
  #
  BODY_PART = {
    "arms_and_shoulders" => {
      name: "Arms & Shoulders",
      training_method: "triset",
      slots: [
        { position: "A1", group: "A", group_type: "triset", category: "triceps", default_exercise: "Dip", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "triset", category: "triceps", default_exercise: "Triceps Extension - Flat - EZ Bar - Close Grip - Semi-Pronated", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "triset", category: "triceps", default_exercise: "French Press - Seated - Triceps Bar - Medium Grip - Neutral", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 90 },
        { position: "B1", group: "B", group_type: "triset", category: "biceps", default_exercise: "Curl - Scott - EZ Bar - Close Grip - Semi-Pronated", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "triset", category: "biceps", default_exercise: "Curl - Seated - DB - Neutral", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "B3", group: "B", group_type: "triset", category: "biceps", default_exercise: "Curl - 55° Incline - DB - Commerford", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 90 },
        { position: "C1", group: "C", group_type: "triset", category: "shoulders", default_exercise: "Lateral Raise - Standing - DB", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "C2", group: "C", group_type: "triset", category: "shoulders", default_exercise: "Lateral Raise - Standing - Telle - DB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "C3", group: "C", group_type: "triset", category: "shoulders", default_exercise: "Lateral Raise - Standing - L Style - DB", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 90 }
      ]
    },
    "chest_and_back" => {
      name: "Chest & Back",
      training_method: "triset",
      slots: [
        { position: "A1", group: "A", group_type: "triset", category: "primary_press", default_exercise: "Incline Press", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "triset", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "triset", category: "assistance_press", default_exercise: "Fly - 25° Decline - DB", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 120 },
        { position: "B1", group: "B", group_type: "triset", category: "primary_pull", default_exercise: "Chin Up - Medium Grip - Neutral", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "triset", category: "assistance_pull", default_exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "B3", group: "B", group_type: "triset", category: "assistance_pull", default_exercise: "Row - Seated - Close Grip - Semi-Supinated", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 120 }
      ]
    },
    "lower_body" => {
      name: "Lower Body",
      training_method: "triset",
      slots: [
        { position: "A1", group: "A", group_type: "triset", category: "primary_squat", default_exercise: "Squat - Heels Elevated", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "triset", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "triset", category: "knee_extension", default_exercise: "Leg Press - Wide Stance", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 180 },
        { position: "B1", group: "B", group_type: "triset", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "triset", category: "hip_extension", default_exercise: "Deadlift - Romanian - DB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "B3", group: "B", group_type: "triset", category: "hip_extension", default_exercise: "Back Extension - Horizontal - Front - BB - Wide Grip", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 120 }
      ]
    },
    "posterior_chain" => {
      name: "Posterior Chain",
      training_method: "heavy_light",
      slots: [
        { position: "A1", group: "A", group_type: "heavy_light", category: "primary_deadlift", default_exercise: "Deadlift - Romanian - Medium Grip", sets: "5", reps: "6", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "heavy_light", category: "hip_extension", default_exercise: "Back Extension - Horizontal", sets: "5", reps: "15", tempo: "2-0-1-0", rest: 180 },
        { position: "B1", group: "B", group_type: "heavy_light", category: "split_stance", default_exercise: "Step Up - Front - DB", sets: "4", reps: "12", tempo: "1-0-1-0", rest: 60 },
        { position: "B2", group: "B", group_type: "heavy_light", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Foot In - Dorsiflexed - Unilateral", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 60 },
        { position: "C", group: "C", group_type: "straight_set", category: "calves", default_exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "25", tempo: "2-0-1-0", rest: 60 }
      ]
    },
    "chest_and_arms" => {
      name: "Chest & Arms",
      training_method: "post_exhaustion",
      slots: [
        { position: "A1", group: "A", group_type: "post_exhaustion", category: "primary_press", default_exercise: "Incline Press", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "post_exhaustion", category: "assistance_press", default_exercise: "Fly - 15° Incline - DB", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 120 },
        { position: "B1", group: "B", group_type: "post_exhaustion", category: "biceps", default_exercise: "Curl - Scott - EZ Bar - Close Grip - Semi-Supinated", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "post_exhaustion", category: "biceps", default_exercise: "Curl - 45° Incline - DB - Supinated", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 60 },
        { position: "B3", group: "B", group_type: "post_exhaustion", category: "triceps", default_exercise: "Triceps Extension - 15° Decline - EZ Bar - Close Grip", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B4", group: "B", group_type: "post_exhaustion", category: "triceps", default_exercise: "French Press - Seated - Mid Pulley - Rope", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 60 }
      ]
    },
    "back_and_shoulders" => {
      name: "Back & Shoulders",
      training_method: "post_exhaustion",
      slots: [
        { position: "A1", group: "A", group_type: "post_exhaustion", category: "primary_pull", default_exercise: "Pull Up - Medium Grip", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "post_exhaustion", category: "assistance_pull", default_exercise: "Pulldown - Straight Arm - Wide Grip - Pronated", sets: "5", reps: "12", tempo: "2-0-1-1", rest: 90 },
        { position: "A3", group: "A", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Press - Seated - Arnold - DB", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A4", group: "A", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Lateral Raise - Seated - DB", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 90 },
        { position: "B1", group: "B", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Trap 3 Raise - Prone - 15° Incline - DB", sets: "4", reps: "15", tempo: "2-0-1-0", rest: 60 },
        { position: "B2", group: "B", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Lateral Raise - Prone - 15° Incline - DB - Pronated", sets: "4", reps: "15", tempo: "2-0-1-0", rest: 60 }
      ]
    },
    "chest" => {
      name: "Chest",
      training_method: "giant_set",
      slots: [
        { position: "A1", group: "A", group_type: "giant_set", category: "primary_press", default_exercise: "Incline Press", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Press - 45° Incline - DB - Neutral Grip", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Press - 15° Incline - DB - Pronating Grip", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A4", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Press - 25° Decline - DB - Neutral Grip", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A5", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Fly - Flat - DB - Pronated Grip", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 180 }
      ]
    },
    "back" => {
      name: "Back",
      training_method: "giant_set",
      slots: [
        { position: "A1", group: "A", group_type: "giant_set", category: "primary_pull", default_exercise: "Pulldown - Wide Grip - Semi-Pronated", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Supinated", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Row - Seated - Close Grip - Neutral", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A4", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Pulldown - Straight Arm - Medium Grip Pronated", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A5", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Row - Seated - Rope to Neck", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 180 }
      ]
    }
  }.freeze

  ALL = UPPER_BODY.merge(LOWER_BODY).merge(FULL_BODY).merge(BODY_PART).freeze

  def self.for(session_type)
    ALL[session_type.to_s]
  end

  def self.upper_body_types
    UPPER_BODY.keys
  end

  def self.lower_body_types
    LOWER_BODY.keys
  end
end
