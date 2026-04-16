# Defines the OSR (Optimizing Strength Ratios) session templates from the
# OptimizingStrengthRatiosResource pages 26-51.
#
# These templates specify the exact exercises for each limiting lift across
# all 4 phases (Acc1, Int1, Acc2, Int2) and both sessions per phase.
#
# For Acc1 and Int2: these templates are used directly with the periodization
# model providing the A-series rep scheme.
#
# For Int1 and Acc2: the example-based sessions in OsrExampleSessions take
# precedence (they include training methods + specific sets/reps/tempo/rest).
# These templates still serve as reference for the base exercise selections.
#
# Upper body sessions use push/pull pairing with row grip following the
# 90-degree principle:
#   OH Press → supinated pull (A) → neutral row (B)
#   Incline Press → neutral pull (A) → supinated row (B)
#   Bench Press → neutral pull (A) → pronated row (B)
#   Dip → pronated pull (A) → neutral row (B)
#
module Kilo
  class OsrSessionTemplates
    # ---------- SQUAT LIMITING LIFT (pages 26-29) ----------
    SQUAT = {
      accumulation: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B1", exercise: "Split Squat - Front Foot Elevated - BB", sets: "3-4", reps: "8-12", tempo: "3-1-1-0", rest: 60 },
          { position: "B2", exercise: "Leg Curl - Standing - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "8-12", tempo: "4-0-1-0", rest: 60 },
          { position: "C1", exercise: "Pendulum Squat - Medium Stance", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 },
          { position: "C2", exercise: "Goodmorning - Seated - BB - Medium Stance", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B", exercise: "Deadlift - Trap Bar - Low Handles", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Plank - Walk Out", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      intensification: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B1", exercise: "Lunge - Alternated - BB", sets: "3-4", reps: "6-10", tempo: "2-0-1-0", rest: 90 },
          { position: "B2", exercise: "Leg Curl - Lying - (2-1) - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 90 },
          { position: "C1", exercise: "Step-Up - Side - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Incline", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B", exercise: "Squat - Pin Touch - BB - Top Range", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Crunch - Kneeling - High Pulley", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      accumulation_2: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B1", exercise: "Split Squat - BB", sets: "3-4", reps: "8-12", tempo: "3-1-1-0", rest: 60 },
          { position: "B2", exercise: "Leg Curl - Kneeling - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "8-12", tempo: "4-0-1-0", rest: 60 },
          { position: "C1", exercise: "Leg Press", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Horizontal", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B", exercise: "Deadlift - Trap Bar - High Handles", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Pallof Press - Mid Pulley", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      intensification_2: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B1", exercise: "Lunge - Alternated - BB", sets: "3-4", reps: "6-10", tempo: "2-0-1-0", rest: 90 },
          { position: "B2", exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 90 },
          { position: "C1", exercise: "Step-Up - Front - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Incline", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B", exercise: "Squat - Quad - BB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Garhammer Raise - Hanging", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      }
    }.freeze

    # ---------- FRONT SQUAT LIMITING LIFT (pages 30-32) ----------
    FRONT_SQUAT = {
      accumulation: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B", exercise: "Squat - Hack - BB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Pendulum Squat - Medium Stance", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 },
          { position: "C2", exercise: "Goodmorning - Standing - BB - Medium Stance", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Deadlift", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B1", exercise: "Split Squat - Front Foot Elevated - BB", sets: "3-4", reps: "8-12", tempo: "3-1-1-0", rest: 60 },
          { position: "B2", exercise: "Leg Curl - Kneeling - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "8-12", tempo: "4-0-1-0", rest: 60 },
          { position: "C1", exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Renegade Row", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      intensification: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B1", exercise: "Lunge - Alternated - BB", sets: "3-4", reps: "6-10", tempo: "2-0-1-0", rest: 90 },
          { position: "B2", exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 90 },
          { position: "C1", exercise: "Step-Up - Heel Elevated - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Horizontal", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B", exercise: "Rack Deadlift - Wide Grip - Below Knee", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Crunch - Pre-Stretch - Swiss Ball", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      accumulation_2: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B", exercise: "Front Squat - Cyclist - BB", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 150 },
          { position: "C1", exercise: "Leg Press", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Incline", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Deadlift", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B1", exercise: "Split Squat - BB", sets: "3-4", reps: "8-12", tempo: "3-1-1-0", rest: 60 },
          { position: "B2", exercise: "Leg Curl - Standing - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "8-12", tempo: "4-0-1-0", rest: 60 },
          { position: "C1", exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Wood Chop - High Pulley", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      intensification_2: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B1", exercise: "Lunge - Walking - BB", sets: "3-4", reps: "6-10", tempo: "2-0-1-0", rest: 90 },
          { position: "B2", exercise: "Leg Curl - Lying - Feet Neutral - Dorsiflexed", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 90 },
          { position: "C1", exercise: "Step-Up - Petersen - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Horizontal", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B", exercise: "Deadlift - Rack - Above Knee - Wide Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Standing - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Leg Raise - Hanging", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      }
    }.freeze

    # ---------- DEADLIFT LIMITING LIFT (pages 33-35) ----------
    DEADLIFT = {
      accumulation: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B1", exercise: "Split Squat - BB", sets: "3-4", reps: "8-12", tempo: "3-1-1-0", rest: 60 },
          { position: "B2", exercise: "Leg Curl - Standing - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "8-12", tempo: "4-0-1-0", rest: 60 },
          { position: "C1", exercise: "Step-Up - Petersen - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Goodmorning - Standing - BB - Medium Stance", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B", exercise: "Deadlift - 2” Deficit - Wide Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Calf Raise - Seated - Machine", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Plank - Contralateral", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      intensification: {
        lower_body_1: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B", exercise: "Squat - Pin Touch - BB - Mid Range", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Step-Up - Front - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Back Extension - Incline", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Deadlift", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B1", exercise: "Lunge - Alternated - BB", sets: "3-4", reps: "6-10", tempo: "2-0-1-0", rest: 90 },
          { position: "B2", exercise: "Glute Ham Raise - Knee Flexion", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 90 },
          { position: "C1", exercise: "Calf Raise - Standing - DB - Unilateral", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Garhammer Raise - Hanging", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      accumulation_2: {
        lower_body_1: [
          { position: "A", exercise: "Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B1", exercise: "Split Squat - Bulgarian - BB", sets: "3-4", reps: "8-12", tempo: "3-1-1-0", rest: 60 },
          { position: "B2", exercise: "Leg Curl - Kneeling - Foot Neutral - Dorsiflexed", sets: "3-4", reps: "8-12", tempo: "4-0-1-0", rest: 60 },
          { position: "C1", exercise: "Step-Up - Side - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Goodmorning - Standing - BB - Medium Stance", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
          { position: "B", exercise: "Rack Deadlift - Above Knee", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Anterior Tibialis Raise - Machine - Seated", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Jackknife - Swiss Ball", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      },
      intensification_2: {
        lower_body_1: [
          { position: "A", exercise: "Front Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B", exercise: "Squat - Cambered Bar", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 150 },
          { position: "C1", exercise: "Step-Up - Front - DB", sets: "3", reps: "10-15", tempo: "1-0-1-0", rest: 45 },
          { position: "C2", exercise: "Reverse Hyper - Feet Medium", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        lower_body_2: [
          { position: "A", exercise: "Deadlift", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 240 },
          { position: "B1", exercise: "Lunge - Drop - BB", sets: "3-4", reps: "6-10", tempo: "2-0-1-0", rest: 90 },
          { position: "B2", exercise: "Glute Ham Raise - Hip Extension", sets: "3-4", reps: "6-10", tempo: "4-0-1-0", rest: 90 },
          { position: "C1", exercise: "Calf Extension - Leg Press", sets: "3", reps: "10-15", tempo: "2-0-1-0", rest: 45 },
          { position: "C2", exercise: "Ab Roll-Out - Kneeling", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ]
      }
    }.freeze

    # ---------- OVERHEAD PRESS LIMITING LIFT (pages 36-39) ----------
    OVERHEAD_PRESS = {
      accumulation: {
        upper_body_1: [
          { position: "A1", exercise: "Press - Standing - DB - One-Arm", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Medium Grip - Semi-Supinated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Lateral Raise - Side Lying - 45° Incline - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Neck Extension - Standing - Swiss Ball", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - 45° Incline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Side Lying - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Lateral Raise - Prone - 35° Incline - DB - Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Seated - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Prone - 45° Incline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      accumulation_2: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Lateral Raise - Lean-Away - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Neck Extension - Low Pulley", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - 15° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Powell Raise - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification_2: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - EZ Bar - Close Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Standing - EZ Bar - Medium Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Seated - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Standing - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Bent-Over - Supported - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      }
    }.freeze

    # ---------- INCLINE PRESS LIMITING LIFT (pages 40-43) ----------
    INCLINE_PRESS = {
      accumulation: {
        upper_body_1: [
          { position: "A1", exercise: "Press - Seated - BB - Medium Grip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "French Press - Standing - Mid Pulley - Rope", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - 45° Incline - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Wide Grip - Semi-Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Side Lying - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Lateral Raise - Prone - 35° Incline - DB - Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification: {
        upper_body_1: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 45° Incline - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Prone - 45° Incline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      accumulation_2: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Powell Raise - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification_2: {
        upper_body_1: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Supinating - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 25° Decline - EZ Bar - Close Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Standing - EZ Bar - Medium Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 45° Incline - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Standing - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Bent-Over - Supported - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      }
    }.freeze

    # ---------- BENCH PRESS LIMITING LIFT (pages 44-47) ----------
    BENCH_PRESS = {
      accumulation: {
        upper_body_1: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Wide Grip - Semi-Supinated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Fly - Unrolling - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 },
          { position: "C2", exercise: "Row - Seated - Rope to Neck", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - 45° Incline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Side Lying - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Lateral Raise - Prone - 35° Incline - DB - Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Flat - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Prone - 45° Incline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      accumulation_2: {
        upper_body_1: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - 25° Decline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Medium Grip - Semi-Supinated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Fly - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 },
          { position: "C2", exercise: "Row - Seated - Rope to Forehead", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 45 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - 45° Incline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Powell Raise - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification_2: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Flat - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - EZ Bar - Close Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Standing - EZ Bar - Medium Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Elbow Out - Pronated - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Standing - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Bent-Over - Supported - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      }
    }.freeze

    # ---------- DIP LIMITING LIFT (pages 48-51) ----------
    DIP = {
      accumulation: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "French Press - Standing - Mid Pulley - Rope", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - 45° Incline - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Side Lying - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Prone - 45° Incline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification: {
        upper_body_1: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 25° Decline - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - One-Arm - DB - Supinating", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Seated - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 45° Incline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Prone - 45° Incline - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      accumulation_2: {
        upper_body_1: [
          { position: "A1", exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Semi-Supinated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Flat - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Seated - Close Grip - Neutral", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Pressdown - High Pulley - Medium Grip - Neutral", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Scott - DB - Supinated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
          { position: "B1", exercise: "Press - Seated - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Pulldown - Lean 45° - Medium Grip - Semi-Pronated", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Seated - Arm in Front - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Powell Raise - Flat - DB", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      },
      intensification_2: {
        upper_body_1: [
          { position: "A1", exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Chin-Up - Medium Grip - Neutral", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 25° Decline - BB - Close Grip", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - One-Arm - DB - Supinating", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "Triceps Extension - 15° Decline - EZ Bar - Close Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 },
          { position: "C2", exercise: "Curl - Standing - EZ Bar - Medium Grip - Semi-Pronated", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 60 }
        ],
        upper_body_2: [
          { position: "A1", exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "A2", exercise: "Pull-Up - Medium Grip - Pronated", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 120 },
          { position: "B1", exercise: "Press - 45° Incline - DB", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "B2", exercise: "Row - Bent-Over - DB - Neutral - One-Arm", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 90 },
          { position: "C1", exercise: "External Rotation - Standing - Arm to Side - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
          { position: "C2", exercise: "Trap 3 - Bent-Over - Supported - DB - One-Arm", sets: "3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
        ]
      }
    }.freeze

    # Master lookup: limiting_lift symbol → template hash
    TEMPLATES = {
      squat: SQUAT,
      front_squat: FRONT_SQUAT,
      deadlift: DEADLIFT,
      overhead_press: OVERHEAD_PRESS,
      incline_press: INCLINE_PRESS,
      bench_press: BENCH_PRESS,
      dip: DIP
    }.freeze

    # Look up a session template for a given limiting lift, phase, and session.
    #
    # @param limiting_lift [Symbol] :squat, :front_squat, :deadlift, :overhead_press, :incline_press, :bench_press, :dip
    # @param phase [Symbol] :accumulation, :intensification, :accumulation_2, :intensification_2
    # @param session_label [Symbol] :lower_body_1, :lower_body_2, :upper_body_1, :upper_body_2
    # @return [Array<Hash>, nil] Array of exercise slot hashes, or nil if not found
    def self.for(limiting_lift, phase, session_label)
      TEMPLATES.dig(limiting_lift, phase, session_label)
    end

    # Returns all available limiting lifts
    def self.limiting_lifts
      TEMPLATES.keys
    end

    # Returns all session labels for a given limiting lift and phase
    def self.session_labels(limiting_lift, phase)
      TEMPLATES.dig(limiting_lift, phase)&.keys || []
    end
  end
end
