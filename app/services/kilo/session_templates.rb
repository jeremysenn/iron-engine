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

  ALL = UPPER_BODY.merge(LOWER_BODY).merge(FULL_BODY).freeze

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
