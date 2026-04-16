# Encodes the complete sessions from the Optimizing Strength Ratios example
# images for Intensification 1 and Accumulation 2.
#
# These are the source of truth for OSR programs in those two phases.
# Each session includes training methods baked into exercise names, plus
# specific sets, reps, tempo, and rest — NOT derived from the periodization model.
#
# For "Max" reps on Chin-ups/Pull-ups: the program generator should substitute
# the A-series primary press set/rep scheme at generation time.
#
# Exercise names use KILO Exercise Database naming conventions.
# Training method exercises are stored as distinct KiloExercise records.
#
# Source: /Optimizing Strength Ratios Course/Examples/{Beginner,Intermediate,Advanced}/
#
module Kilo
  class OsrExampleSessions
    # =========================================================================
    # BEGINNER
    # =========================================================================
    BEGINNER = {
      # ----- SQUAT -----
      squat: {
        accumulation_2: {
          lower_body_1: [
            { position: "A", exercise: "Squat - Inertia - Top Range", sets: 4, reps: "8", tempo: "22X0", rest: 180 },
            { position: "B1", exercise: "Split Squat - BB", sets: 3, reps: "12", tempo: "3110", rest: 60 },
            { position: "B2", exercise: "Leg Curl - Standing - Foot Neutral - Dorsiflexed", sets: 3, reps: "8", tempo: "4010", rest: 60 },
            { position: "C1", exercise: "Step-Up - Heel Elevated - DB", sets: 3, reps: "12", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Back Extension - Horizontal", sets: 3, reps: "12", tempo: "3011", rest: 45 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Squat", sets: 4, reps: "8", tempo: "40X0", rest: 240 },
            { position: "B", exercise: "Squat - Quad - Extended Eccentric", sets: 4, reps: "5", tempo: "60X0", rest: 180 },
            { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: 3, reps: "10", tempo: "2010", rest: 45 },
            { position: "C2", exercise: "Hip Raise - Supine", sets: 3, reps: "Max", tempo: "3010", rest: 45 }
          ]
        }
      },

      # ----- FRONT SQUAT -----
      front_squat: {
        accumulation_2: {
          lower_body_1: [
            { position: "A", exercise: "Squat", sets: 4, reps: "11", tempo: "40X0", rest: 180 },
            { position: "B", exercise: "Squat - Cyclist - BB - with Chains", sets: 4, reps: "8", tempo: "20X0", rest: 150 },
            { position: "C1", exercise: "Step-Up - Heel Elevated - DB", sets: 3, reps: "12", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Back Extension - Horizontal", sets: 3, reps: "12", tempo: "3011", rest: 45 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Front Squat - Mechanical Disadvantage", sets: 4, reps: "4", tempo: "42X0", rest: 240 },
            { position: "B", exercise: "Deadlift - Rack - Mid Thigh - Medium Grip", sets: 4, reps: "8", tempo: "2110", rest: 180 },
            { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: 3, reps: "10", tempo: "2010", rest: 45 },
            { position: "C2", exercise: "Hip Raise - Supine", sets: 3, reps: "Max", tempo: "3010", rest: 45 }
          ]
        }
      },

      # ----- DEADLIFT -----
      deadlift: {
        accumulation_2: {
          lower_body_2: [
            { position: "A", exercise: "Front Squat", sets: 4, reps: "4", tempo: "40X0", rest: 240 },
            { position: "B", exercise: "Deadlift - Trap Bar - with Bands", sets: 4, reps: "8", tempo: "20X0", rest: 180 },
            { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: 3, reps: "10", tempo: "2010", rest: 45 },
            { position: "C2", exercise: "Hip Raise - Supine", sets: 3, reps: "Max", tempo: "3010", rest: 45 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Deadlift - 3-Pause Eccentric", sets: 4, reps: "4", tempo: "61X0", rest: 240 },
            { position: "B1", exercise: "Lunge - Alternated - BB", sets: 3, reps: "8", tempo: "2010", rest: 60 },
            { position: "B2", exercise: "Leg Curl - Lying - (2-1) - Foot Neutral - Dorsiflexed", sets: 3, reps: "8", tempo: "4010", rest: 60 },
            { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: 3, reps: "10", tempo: "2010", rest: 45 },
            { position: "C2", exercise: "Hip Raise - Supine", sets: 3, reps: "Max", tempo: "3010", rest: 45 }
          ]
        }
      },

      # ----- OVERHEAD PRESS -----
      overhead_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Press - Seated - Inertia - Bottom Range", sets: 4, reps: "8", tempo: "22X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 4, reps: "8", tempo: "20X0", rest: 90 },
            { position: "B1", exercise: "Press - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Medium Grip - Neutral", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          upper_body_2: [
            { position: "A1", exercise: "Bench Press", sets: 4, reps: "8", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 4, reps: "Max", tempo: "2010", rest: 120 },
            { position: "B1", exercise: "Press - Seated - DB - Extended Eccentric", sets: 3, reps: "5", tempo: "60X0", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      },

      # ----- INCLINE PRESS -----
      incline_press: {
        accumulation_2: {
          upper_body_2: [
            { position: "A1", exercise: "Bench Press", sets: 4, reps: "8", tempo: "40X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 4, reps: "Max", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - Seated - DB - Myotatic 1/4", sets: 3, reps: "8", tempo: "20X0", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Wide Grip - Semi-Pronated", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: 3, reps: "12", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Powell Raise - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 30 }
          ]
        },
        intensification: {
          upper_body_2: [
            { position: "A1", exercise: "Dip", sets: 4, reps: "8", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: 4, reps: "Max", tempo: "2010", rest: 120 },
            { position: "B1", exercise: "Press - Incline - DB - Sticking Point Pause", sets: 3, reps: "8", tempo: "30X2", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      },

      # ----- BENCH PRESS -----
      bench_press: {
        accumulation_2: {
          upper_body_2: [
            { position: "A1", exercise: "Dip", sets: 4, reps: "8", tempo: "40X0", rest: 90 },
            { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: 4, reps: "Max", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - Incline Close-Grip - with Chains", sets: 3, reps: "8", tempo: "20X0", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: 3, reps: "12", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Powell Raise - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 30 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press", sets: 4, reps: "8", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 4, reps: "Max", tempo: "2010", rest: 120 },
            { position: "B1", exercise: "Press - Seated - Flat - DB - 3-Pause Eccentric", sets: 3, reps: "4", tempo: "60X0", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ]
        }
      },

      # ----- DIP -----
      dip: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press", sets: 4, reps: "8", tempo: "40X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 4, reps: "Max", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - Flat - Inertia - Mid Range", sets: 3, reps: "8", tempo: "22X0", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Incline Press", sets: 4, reps: "8", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 4, reps: "Max", tempo: "2010", rest: 120 },
            { position: "B1", exercise: "Press - Decline Close-Grip - Con-Ecc", sets: 3, reps: "6+2", tempo: "4000", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ]
        }
      }
    }.freeze

    # =========================================================================
    # INTERMEDIATE
    # =========================================================================
    INTERMEDIATE = {
      # ----- SQUAT -----
      squat: {
        accumulation_2: {
          lower_body_1: [
            { position: "A", exercise: "Squat - Inertia - Mid Range", sets: 5, reps: "6", tempo: "22X0", rest: 180 },
            { position: "B1", exercise: "Split Squat - BB", sets: 4, reps: "10", tempo: "3110", rest: 60 },
            { position: "B2", exercise: "Leg Curl - Lying - Foot Neutral - Dorsiflexed - Unilateral", sets: 4, reps: "8", tempo: "4010", rest: 60 },
            { position: "C1", exercise: "Step-Up - Petersen - DB", sets: 3, reps: "12", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Reverse Hyper - Feet Medium", sets: 3, reps: "12", tempo: "3010", rest: 45 }
          ]
        },
        intensification: {
          lower_body_1: [
            { position: "A", exercise: "Squat - Eccentric Hook", sets: 5, reps: "4", tempo: "40X0", rest: 240 },
            { position: "B1", exercise: "Lunge - Alternated - BB", sets: 3, reps: "8", tempo: "2010", rest: 90 },
            { position: "B2", exercise: "Glute Ham Raise - Knee Flexion", sets: 3, reps: "8", tempo: "4010", rest: 90 },
            { position: "C1", exercise: "Step-Up - Side - DB", sets: 3, reps: "10", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Deadlift - Romanian - BB - Medium Grip", sets: 3, reps: "10", tempo: "3010", rest: 45 }
          ]
        }
      },

      # ----- FRONT SQUAT -----
      front_squat: {
        accumulation_2: {
          lower_body_1: [
            { position: "A", exercise: "Squat - with Bands", sets: 5, reps: "6", tempo: "20X0", rest: 180 },
            { position: "B", exercise: "Squat - Cyclist - BB", sets: 5, reps: "8", tempo: "4010", rest: 150 },
            { position: "C1", exercise: "Pendulum Squat - Medium Stance", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Back Extension - Incline", sets: 3, reps: "12", tempo: "3010", rest: 45 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Front Squat - 3-Pause Eccentric", sets: 5, reps: "3", tempo: "60X0", rest: 240 },
            { position: "B", exercise: "Deadlift - Rack - Above Knee - Wide Grip", sets: 4, reps: "8", tempo: "2110", rest: 180 },
            { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: 3, reps: "10", tempo: "2010", rest: 60 },
            { position: "C2", exercise: "Garhammer Raise - Hanging", sets: 3, reps: "Max", tempo: "2010", rest: 60 }
          ]
        }
      },

      # ----- DEADLIFT -----
      deadlift: {
        accumulation_2: {
          lower_body_2: [
            { position: "A", exercise: "Front Squat", sets: 4, reps: "4", tempo: "40X0", rest: 180 },
            { position: "B", exercise: "Rack Deadlift - Below Knee - with Bands", sets: 4, reps: "8", tempo: "21X0", rest: 150 },
            { position: "C1", exercise: "Calf Raise - Seated - Machine", sets: 3, reps: "12", tempo: "2111", rest: 60 },
            { position: "C2", exercise: "Crunch - Pre-Stretch - Swiss Ball", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Deadlift - Sticking Point Pause", sets: 5, reps: "3", tempo: "41X2", rest: 240 },
            { position: "B1", exercise: "Lunge - Alternated - BB", sets: 3, reps: "8", tempo: "2010", rest: 60 },
            { position: "B2", exercise: "Leg Curl - Lying - (2-1) - Foot Neutral - Dorsiflexed", sets: 3, reps: "5", tempo: "6010", rest: 60 },
            { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: 3, reps: "10", tempo: "2010", rest: 60 },
            { position: "C2", exercise: "Garhammer Raise - Hanging", sets: 3, reps: "Max", tempo: "3010", rest: 60 }
          ]
        }
      },

      # ----- OVERHEAD PRESS -----
      overhead_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Press - Seated - with Chains", sets: 5, reps: "6", tempo: "20X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "10", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press - Extended Eccentric", sets: 5, reps: "4", tempo: "80X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "7", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Flat - BB - Close Grip", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ]
        }
      },

      # ----- INCLINE PRESS -----
      incline_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press - with Bands", sets: 5, reps: "6", tempo: "20X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "10", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Incline Press - 3-Pause Concentric", sets: 5, reps: "3", tempo: "4060", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "7", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - 25° Decline - DB", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - 15° Decline - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ]
        }
      },

      # ----- BENCH PRESS -----
      bench_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Incline Press - Inertia - Bottom Range", sets: 5, reps: "6", tempo: "22X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "10", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - 25° Decline - DB", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Medium Grip - Semi-Supinated", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          upper_body_2: [
            { position: "A1", exercise: "Bench Press - Mechanical Disadvantage", sets: 5, reps: "4", tempo: "44X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "7", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Seated - DB", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      },

      # ----- DIP -----
      dip: {
        accumulation_2: {
          upper_body_2: [
            { position: "A1", exercise: "Bench Press - Myotatic 1/3", sets: 5, reps: "6", tempo: "20X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "10", tempo: "2010", rest: 90 },
            { position: "B1", exercise: "Press - Seated - DB", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Medium Grip - Semi-Pronated", sets: 3, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: 3, reps: "12", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Powell Raise - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 30 }
          ]
        },
        intensification: {
          upper_body_2: [
            { position: "A1", exercise: "Dip - Sticking Point Pause", sets: 5, reps: "3", tempo: "40X4", rest: 120 },
            { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: 5, reps: "7", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - 45° Incline - BB - Close Grip", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      }
    }.freeze

    # =========================================================================
    # ADVANCED
    # =========================================================================
    # Advanced has TWO sessions per body region in Intensification 1 (Upper Body 1 + 2
    # or Lower Body 1 + 2), while Accumulation 2 typically has one session per region.
    # Upper body limiting lifts also get methods on BOTH UB sessions in Int1.
    ADVANCED = {
      # ----- SQUAT -----
      squat: {
        accumulation_2: {
          lower_body_1: [
            { position: "A", exercise: "Squat - Deadstop - Mid Range", sets: 5, reps: "4", tempo: "24X0", rest: 180 },
            { position: "B1", exercise: "Split Squat - Bulgarian - BB", sets: 4, reps: "10", tempo: "3010", rest: 60 },
            { position: "B2", exercise: "Leg Curl - Kneeling - Foot Neutral - Dorsiflexed", sets: 4, reps: "8", tempo: "4010", rest: 60 },
            { position: "C1", exercise: "Step-Up - Petersen - DB", sets: 3, reps: "12", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Reverse Hyper - Feet Medium", sets: 3, reps: "12", tempo: "3010", rest: 45 }
          ]
        },
        intensification: {
          lower_body_1: [
            { position: "A", exercise: "Squat - Eccentric Hook", sets: 5, reps: "2", tempo: "80X0", rest: 240 },
            { position: "B1", exercise: "Lunge - Drop - BB", sets: 3, reps: "8", tempo: "2010", rest: 90 },
            { position: "B2", exercise: "Glute Ham Raise - Knee Flexion", sets: 3, reps: "8", tempo: "4010", rest: 90 },
            { position: "C1", exercise: "Step-Up - Front - DB", sets: 3, reps: "10", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Goodmorning - Standing - BB - Medium Stance", sets: 3, reps: "10", tempo: "3010", rest: 45 }
          ],
          lower_body_2: [
            { position: "A", exercise: "Squat", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 240 },
            { position: "B", exercise: "Squat - Quad - 3-Pause Eccentric", sets: 4, reps: "8", tempo: "6010", rest: 180 },
            { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: 3, reps: "10", tempo: "2010", rest: 60 },
            { position: "C2", exercise: "Ab Roll-Out - Kneeling", sets: 3, reps: "Max", tempo: "3010", rest: 60 }
          ]
        }
      },

      # ----- FRONT SQUAT -----
      front_squat: {
        accumulation_2: {
          lower_body_1: [
            { position: "A", exercise: "Squat - with Bands", sets: 5, reps: "4", tempo: "20X0", rest: 180 },
            { position: "B", exercise: "Squat - Quad - BB", sets: 5, reps: "10", tempo: "4010", rest: 150 },
            { position: "C1", exercise: "Step-Up - Petersen - DB", sets: 3, reps: "12", tempo: "1010", rest: 45 },
            { position: "C2", exercise: "Reverse Hyper - Feet Medium", sets: 3, reps: "12", tempo: "3010", rest: 45 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Front Squat - 3-Pause Concentric", sets: 5, reps: "2", tempo: "4060", rest: 240 },
            { position: "B", exercise: "Deadlift - Rack - Above Knee - Wide Grip", sets: 4, reps: "8", tempo: "2110", rest: 180 },
            { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: 3, reps: "10", tempo: "2010", rest: 60 },
            { position: "C2", exercise: "Ab Roll-Out - Kneeling", sets: 3, reps: "Max", tempo: "3010", rest: 60 }
          ]
        }
      },

      # ----- DEADLIFT -----
      deadlift: {
        accumulation_2: {
          lower_body_2: [
            { position: "A", exercise: "Front Squat", sets: 5, reps: "5,5,4,4,4", tempo: "40X0", rest: 180 },
            { position: "B", exercise: "Deadlift - Deficit - with Chains", sets: 5, reps: "4", tempo: "21X0", rest: 150 },
            { position: "C1", exercise: "Anterior Tibialis Raise - Machine - Seated", sets: 3, reps: "10", tempo: "2011", rest: 60 },
            { position: "C2", exercise: "Crunch - Kneeling - High Pulley", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          lower_body_2: [
            { position: "A", exercise: "Deadlift - Extended Eccentric", sets: 5, reps: "3", tempo: "101X0", rest: 240 },
            { position: "B1", exercise: "Lunge - Walking - BB", sets: 3, reps: "8", tempo: "2010", rest: 90 },
            { position: "B2", exercise: "Glute Ham Raise - Knee Flexion", sets: 3, reps: "8", tempo: "4010", rest: 90 },
            { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: 3, reps: "10", tempo: "2010", rest: 60 },
            { position: "C2", exercise: "Leg Raise - Hanging", sets: 3, reps: "Max", tempo: "4010", rest: 60 }
          ]
        }
      },

      # ----- OVERHEAD PRESS -----
      overhead_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Press - Seated - DB - Myotatic 1/3", sets: 5, reps: "4", tempo: "20X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - Flat - DB", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press - Sticking Point", sets: 5, reps: "2", tempo: "40X4", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Flat - DB", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Bench Press", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Seated Close-Grip - Con-Ecc", sets: 3, reps: "4+2", tempo: "8000", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      },

      # ----- INCLINE PRESS -----
      incline_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press - with Bands", sets: 5, reps: "4", tempo: "20X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - Flat - DB", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Bench Press", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - Seated - DB - Myotatic 1/3", sets: 4, reps: "4", tempo: "20X0", rest: 90 },
            { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: 3, reps: "12", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Powell Raise - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 30 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Incline Press - Con-Ecc", sets: 5, reps: "3+2", tempo: "10000", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - 25° Decline - DB", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - 15° Decline - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Dip", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Incline - DB - Sticking Point Pause", sets: 3, reps: "4", tempo: "40X4", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      },

      # ----- BENCH PRESS -----
      bench_press: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Incline Press - Deadstop - Bottom Range", sets: 5, reps: "4", tempo: "44X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - 25° Decline - DB", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Medium Grip - Semi-Supinated", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Dip", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - Incline Close-Grip - with Chains", sets: 4, reps: "4", tempo: "20X0", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: 3, reps: "12", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Powell Raise - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 30 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Flat - DB - 3-Pause Eccentric", sets: 3, reps: "2", tempo: "120X0", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Bench Press - Eccentric Only", sets: 5, reps: "2", tempo: "8000", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Seated - DB", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      },

      # ----- DIP -----
      dip: {
        accumulation_2: {
          upper_body_1: [
            { position: "A1", exercise: "Overhead Press", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - Flat - Inertia - Bottom Range", sets: 4, reps: "5", tempo: "24X0", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: 3, reps: "12", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: 3, reps: "12", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Bench Press - with Bands", sets: 5, reps: "4", tempo: "20X0", rest: 90 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "10,10,8,8,8", tempo: "40X0", rest: 90 },
            { position: "B1", exercise: "Press - Seated - DB", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Seated - Medium Grip - Semi-Pronated", sets: 4, reps: "10", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: 3, reps: "12", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Powell Raise - Flat - DB", sets: 3, reps: "12", tempo: "3010", rest: 30 }
          ]
        },
        intensification: {
          upper_body_1: [
            { position: "A1", exercise: "Incline Press", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - Decline - Extended Eccentric", sets: 3, reps: "2", tempo: "150X0", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "Triceps Extension - Flat - DB", sets: 3, reps: "10", tempo: "3010", rest: 60 },
            { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: 3, reps: "10", tempo: "3010", rest: 60 }
          ],
          upper_body_2: [
            { position: "A1", exercise: "Dip - Mechanical Disadvantage", sets: 5, reps: "3", tempo: "44X0", rest: 120 },
            { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: 5, reps: "8,7,6,5,4", tempo: "40X0", rest: 120 },
            { position: "B1", exercise: "Press - 45° Incline - DB", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: 3, reps: "8", tempo: "3010", rest: 90 },
            { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 },
            { position: "C2", exercise: "Trap 3 - Prone - 35° Incline - DB - One-Arm", sets: 3, reps: "10", tempo: "3010", rest: 30 }
          ]
        }
      }
    }.freeze

    # Master lookup: training_level symbol → per-lift sessions
    SESSIONS = {
      beginner: BEGINNER,
      intermediate: INTERMEDIATE,
      advanced: ADVANCED
    }.freeze

    # Look up example sessions for a given training level, limiting lift, and phase.
    #
    # @param training_level [Symbol] :beginner, :intermediate, :advanced
    # @param limiting_lift [Symbol] :squat, :front_squat, :deadlift, :overhead_press, :incline_press, :bench_press, :dip
    # @param phase [Symbol] :intensification (Int1) or :accumulation_2 (Acc2)
    # @return [Hash<Symbol, Array<Hash>>] session_label => exercises array, or nil
    def self.for(training_level, limiting_lift, phase)
      SESSIONS.dig(training_level, limiting_lift, phase)
    end

    # Map client training_age enum to OSR training level
    def self.training_level_for(training_age)
      case training_age.to_s
      when "novice" then :beginner
      when "intermediate" then :intermediate
      when "advanced" then :advanced
      else :beginner
      end
    end
  end
end
