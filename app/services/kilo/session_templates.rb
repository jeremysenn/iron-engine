# Defines the KILO session templates from the Program Design Resource and
# Training Split Database. Exercise names match the KILO Exercise Database.
#
# Coaches can override any exercise in any slot with any exercise from
# the KILO Exercise Database, a custom exercise they created, or a new entry.
#
module Kilo::SessionTemplates
  UPPER_BODY = {
    "overhead_press" => {
      name: "Overhead Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Seated - Close Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "triceps", default_exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "biceps", default_exercise: "Curl - Scott - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    },
    "incline_press" => {
      name: "Incline Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Seated - Medium Grip - Semi-Supinated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "triceps", default_exercise: "Triceps Extension - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "biceps", default_exercise: "Curl - Scott - EZ Bar - Close Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    },
    "bench_press" => {
      name: "Bench Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Seated - Wide Grip - Semi-Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation - Sideway - Low Pulley - Neutral - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "scapular_retraction", default_exercise: "Lateral Raise - Seated - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    },
    "dip" => {
      name: "Dip",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - 15° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "scapular_retraction", default_exercise: "Trap 3 - Prone - 45° Incline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    }
  }.freeze

  LOWER_BODY = {
    "squat_1" => {
      name: "Squat 1",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat - DB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "knee_extension", default_exercise: "Leg Press - Narrow Stance", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "hip_extension", default_exercise: "Deadlift - Romanian - DB", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    },
    "squat_2" => {
      name: "Squat 2",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "4-5", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "knee_extension", default_exercise: "Leg Press - Narrow Stance", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "hip_extension", default_exercise: "Back Extension - Incline - DB", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    },
    "front_squat" => {
      name: "Front Squat",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "4-6", reps: "1-6", tempo: "4-0-X-0" },
        { position: "B", category: "specialty_deadlift", default_exercise: "Deadlift - Rack - Mid Thigh - Wide Grip", sets: "4-5", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "calves", default_exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "abdominal", default_exercise: "Crunch - Swiss Ball", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    },
    "deadlift" => {
      name: "Deadlift",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "4-6", reps: "1-6", tempo: "4-1-X-0" },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat - DB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl - Standing - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "calves", default_exercise: "Anterior Tibialis Raise - Machine - Seated", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "abdominal", default_exercise: "Pallof Press - Mid Pulley", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    }
  }.freeze

  FULL_BODY = {
    "squat_1_overhead_press" => {
      name: "Squat 1 & Overhead Press",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "3-4", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Press - Seated - BB - Medium Grip", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Close Grip - Semi-Supinated", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C1", category: "split_stance", default_exercise: "Split Squat - DB", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C2", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    },
    "front_squat_incline_press" => {
      name: "Front Squat & Incline Press",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "3-4", reps: "1-6", tempo: "4-0-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Press - 35° Incline - DB", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C", category: "specialty_deadlift", default_exercise: "Deadlift - Rack - Mid Thigh - Wide Grip", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Pronated", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    },
    "squat_2_bench_press" => {
      name: "Squat 2 & Bench Press",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "3-4", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Bench Press", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - Seated - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Supinating", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    },
    "deadlift_dip" => {
      name: "Deadlift & Dip",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "3-4", reps: "1-6", tempo: "4-1-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Dip", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C1", category: "split_stance", default_exercise: "Split Squat - DB", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C2", category: "knee_flexion", default_exercise: "Leg Curl - Standing - Foot Neutral - Dorsiflexed", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - 15° Decline - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
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
        { position: "C3", group: "C", group_type: "triset", category: "shoulders", default_exercise: "Lateral Raise - Standing - L-Style - DB", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 90 }
      ]
    },
    "chest_and_back" => {
      name: "Chest & Back",
      training_method: "triset",
      slots: [
        { position: "A1", group: "A", group_type: "triset", category: "primary_press", default_exercise: "Press - 35° Incline - DB", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "triset", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "triset", category: "assistance_press", default_exercise: "Fly - 25° Decline - DB", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 120 },
        { position: "B1", group: "B", group_type: "triset", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "triset", category: "assistance_pull", default_exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "B3", group: "B", group_type: "triset", category: "assistance_pull", default_exercise: "Row - Seated - Close Grip - Semi-Supinated", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 120 }
      ]
    },
    "lower_body" => {
      name: "Lower Body",
      training_method: "triset",
      slots: [
        { position: "A1", group: "A", group_type: "triset", category: "primary_squat", default_exercise: "Squat", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "triset", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "triset", category: "knee_extension", default_exercise: "Leg Press - Wide Stance", sets: "4", reps: "12", tempo: "3-0-1-0" },
        { position: "B1", group: "B", group_type: "triset", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "4", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "triset", category: "hip_extension", default_exercise: "Deadlift - Romanian - DB", sets: "4", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "B3", group: "B", group_type: "triset", category: "hip_extension", default_exercise: "Back Extension - Horizontal - Front - BB", sets: "4", reps: "12", tempo: "3-0-1-0", rest: 120 }
      ]
    },
    "posterior_chain" => {
      name: "Posterior Chain",
      training_method: "heavy_light",
      slots: [
        { position: "A1", group: "A", group_type: "heavy_light", category: "primary_deadlift", default_exercise: "Deadlift - Romanian - BB - Medium Grip", sets: "5", reps: "6", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "heavy_light", category: "hip_extension", default_exercise: "Back Extension - Horizontal", sets: "5", reps: "15", tempo: "2-0-1-0" },
        { position: "B1", group: "B", group_type: "heavy_light", category: "split_stance", default_exercise: "Step-Up - Front - DB", sets: "4", reps: "12", tempo: "1-0-1-0" },
        { position: "B2", group: "B", group_type: "heavy_light", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Foot In - Dorsiflexed - Unilateral", sets: "4", reps: "8", tempo: "4-0-1-0" },
        { position: "C", group: "C", group_type: "straight_set", category: "calves", default_exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "25", tempo: "2-0-1-0", rest: 60 }
      ]
    },
    "chest_and_arms" => {
      name: "Chest & Arms",
      training_method: "post_exhaustion",
      slots: [
        { position: "A1", group: "A", group_type: "post_exhaustion", category: "primary_press", default_exercise: "Press - 35° Incline - DB", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "post_exhaustion", category: "assistance_press", default_exercise: "Fly - 15° Incline - DB", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 120 },
        { position: "B1", group: "B", group_type: "post_exhaustion", category: "biceps", default_exercise: "Curl - Scott - EZ Bar - Close Grip - Semi-Supinated", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B2", group: "B", group_type: "post_exhaustion", category: "biceps", default_exercise: "Curl - 45° Incline - DB - Supinated", sets: "5", reps: "12", tempo: "3-0-1-0" },
        { position: "B3", group: "B", group_type: "post_exhaustion", category: "triceps", default_exercise: "Triceps Extension - 15° Decline - EZ Bar - Close Grip - Semi-Pronated", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "B4", group: "B", group_type: "post_exhaustion", category: "triceps", default_exercise: "French Press - Seated - Low Pulley - Rope", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 60 }
      ]
    },
    "back_and_shoulders" => {
      name: "Back & Shoulders",
      training_method: "post_exhaustion",
      slots: [
        { position: "A1", group: "A", group_type: "post_exhaustion", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "post_exhaustion", category: "assistance_pull", default_exercise: "Pulldown - Straight-Arm - Standing - Wide Grip - Pronated", sets: "5", reps: "12", tempo: "2-0-1-1", rest: 90 },
        { position: "A3", group: "A", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Press - Seated - Arnold - DB", sets: "5", reps: "8", tempo: "4-0-1-0", rest: 10 },
        { position: "A4", group: "A", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Lateral Raise - Seated - DB", sets: "5", reps: "12", tempo: "3-0-1-0", rest: 90 },
        { position: "B1", group: "B", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Trap 3 - Prone - 15° Incline - DB", sets: "4", reps: "15", tempo: "2-0-1-0" },
        { position: "B2", group: "B", group_type: "post_exhaustion", category: "shoulders", default_exercise: "Lateral Raise - Prone - 15° Incline - DB - Pronated", sets: "4", reps: "15", tempo: "2-0-1-0", rest: 60 }
      ]
    },
    "chest" => {
      name: "Chest",
      training_method: "giant_set",
      slots: [
        { position: "A1", group: "A", group_type: "giant_set", category: "primary_press", default_exercise: "Press - 35° Incline - DB", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Press - 45° Incline - DB", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A4", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A5", group: "A", group_type: "giant_set", category: "assistance_press", default_exercise: "Fly - Flat - DB", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 180 }
      ]
    },
    "back" => {
      name: "Back",
      training_method: "giant_set",
      slots: [
        { position: "A1", group: "A", group_type: "giant_set", category: "primary_pull", default_exercise: "Pulldown - Wide Grip - Semi-Pronated", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A2", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Supinated", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A3", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Row - Seated - Close Grip - Neutral", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A4", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Pulldown - Straight-Arm - Standing - Medium Grip - Pronated", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 10 },
        { position: "A5", group: "A", group_type: "giant_set", category: "assistance_pull", default_exercise: "Row - Seated - Rope to Neck", sets: "5", reps: "10", tempo: "3-0-1-0", rest: 180 }
      ]
    }
  }.freeze

  # ── Phase-Specific Templates ────────────────────────────────────────
  #
  # Accumulation phases use the base templates above (UPPER_BODY, LOWER_BODY, etc.).
  #
  # Intensification phases use the _INT templates below. These start as copies
  # of the base templates — edit any slot's default_exercise, sets, reps, or
  # tempo to customize intensification defaults.
  #
  # Example: to change split_stance in intensification lower body sessions,
  # find the slot with category: "split_stance" and change default_exercise.
  #

  UPPER_BODY_INT = {
    "overhead_press" => {
      name: "Overhead Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Close Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "triceps", default_exercise: "Triceps Extension - Flat - EZ Bar - Close Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "biceps", default_exercise: "Curl - Seated - DB - Zottman", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    },
    "incline_press" => {
      name: "Incline Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "triceps", default_exercise: "French Press - Standing - Mid Pulley - Rope", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "biceps", default_exercise: "Curl - 45° Incline - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    },
    "bench_press" => {
      name: "Bench Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "scapular_retraction", default_exercise: "Lateral Raise - Prone - 15° Incline - DB - Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    },
    "dip" => {
      name: "Dip",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "A2", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "assistance_press", default_exercise: "Press - 15° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "B2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Arc - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0" },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation - Elbow on Knee - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0" },
        { position: "C2", category: "scapular_retraction", default_exercise: "Powell Raise - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0" }
      ]
    }
  }.freeze

  LOWER_BODY_INT = {
    "squat_1" => {
      name: "Squat 1",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "split_stance", default_exercise: "Lunge - Alternated - DB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "B2", category: "knee_flexion", default_exercise: "Glute Ham Raise - Knee Flexion", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "knee_extension", default_exercise: "Step-Up - Front - DB", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "hip_extension", default_exercise: "Back Extension - Horizontal", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    },
    "squat_2" => {
      name: "Squat 2",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "4-5", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "knee_extension", default_exercise: "Step-Up - Front - DB", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "hip_extension", default_exercise: "Reverse Hyper - Feet Medium", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    },
    "front_squat" => {
      name: "Front Squat",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "4-6", reps: "1-6", tempo: "4-0-X-0" },
        { position: "B", category: "specialty_deadlift", default_exercise: "Deadlift - Rack - Mid Thigh - Wide Grip", sets: "4-5", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "calves", default_exercise: "Calf Extension - Leg Press", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "abdominal", default_exercise: "Garhammer Raise - Hanging", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    },
    "deadlift" => {
      name: "Deadlift",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "4-6", reps: "1-6", tempo: "4-1-X-0" },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat - Front Foot Elevated - DB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C1", category: "calves", default_exercise: "Calf Raise - Standing - Machine", sets: "3", reps: "10-20", tempo: "3-0-1-0" },
        { position: "C2", category: "abdominal", default_exercise: "Ab Roll-Out - Kneeling", sets: "3", reps: "10-20", tempo: "3-0-1-0" }
      ]
    }
  }.freeze

  FULL_BODY_INT = {
    "squat_1_overhead_press" => {
      name: "Squat 1 & Overhead Press",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "3-4", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Press - Seated - BB - Medium Grip", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Close Grip - Semi-Supinated", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C1", category: "split_stance", default_exercise: "Lunge - Alternated - DB", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C2", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - Flat - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    },
    "front_squat_incline_press" => {
      name: "Front Squat & Incline Press",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "3-4", reps: "1-6", tempo: "4-0-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Press - 35° Incline - DB", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C", category: "specialty_deadlift", default_exercise: "Deadlift - Rack - Mid Thigh - Wide Grip", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - 25° Decline - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Pronated", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    },
    "squat_2_bench_press" => {
      name: "Squat 2 & Bench Press",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Squat", sets: "3-4", reps: "1-12", tempo: "4-0-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Bench Press", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Chin-Up - Medium Grip - Neutral", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C", category: "specialty_squat", default_exercise: "Squat - Hack - BB", sets: "3-4", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - Seated - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Supinating", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    },
    "deadlift_dip" => {
      name: "Deadlift & Dip",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "3-4", reps: "1-6", tempo: "4-1-X-0" },
        { position: "B1", category: "primary_press", default_exercise: "Dip", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "B2", category: "primary_pull", default_exercise: "Pull-Up - Medium Grip - Pronated", sets: "3-4", reps: "1-12", tempo: "4-0-X-0", primary: true },
        { position: "C1", category: "split_stance", default_exercise: "Split Squat - Front Foot Elevated - DB", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "C2", category: "knee_flexion", default_exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3", reps: "6-12", tempo: "3-0-1-0" },
        { position: "D1", category: "assistance_press", default_exercise: "Press - 15° Decline - DB", sets: "3", reps: "6-10", tempo: "3-0-1-0" },
        { position: "D2", category: "assistance_pull", default_exercise: "Row - Bent-Over - DB - Neutral", sets: "3", reps: "6-10", tempo: "3-0-1-0" }
      ]
    }
  }.freeze

  BODY_PART_INT = BODY_PART

  ALL = UPPER_BODY.merge(LOWER_BODY).merge(FULL_BODY).merge(BODY_PART).freeze

  PHASE_TEMPLATES = {
    accumulation:    ALL,
    intensification: UPPER_BODY_INT.merge(LOWER_BODY_INT).merge(FULL_BODY_INT).merge(BODY_PART_INT).freeze
  }.freeze

  # Looks up a session template by type, optionally phase-specific.
  # Falls back to the base (phase-agnostic) template if no phase override exists.
  def self.for(session_type, phase: nil)
    key = session_type.to_s
    if phase
      phase_key = phase.to_sym
      PHASE_TEMPLATES.dig(phase_key, key) || ALL[key]
    else
      ALL[key]
    end
  end

  def self.upper_body_types
    UPPER_BODY.keys
  end

  def self.lower_body_types
    LOWER_BODY.keys
  end
end
