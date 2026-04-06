# Defines the 8 KILO session templates from the Program Design Resource.
#
# Each template specifies default exercises for each position slot,
# with set/rep ranges, tempos, and rest periods.
#
# Coaches can override any exercise in any slot. These are DEFAULTS,
# not hard requirements.
#
# Upper body templates follow the 90-degree principle:
#   Within microcycle: OH Press <-> Bench Press, Incline Press <-> Dip
#   Within session: A1 primary -> B1 assistance (90-degree pair)
#   Chin-up/row grip matches the primary press
#
module Kilo::SessionTemplates
  UPPER_BODY = {
    "overhead_press" => {
      name: "Overhead Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Overhead Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up (Supinated)", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "B1", category: "assistance_press", default_exercise: "Flat DB Press", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row (Neutral Grip)", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "triceps", default_exercise: "Triceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "biceps", default_exercise: "Biceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "incline_press" => {
      name: "Incline Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Incline Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up (Neutral)", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "B1", category: "assistance_press", default_exercise: "Decline DB Press", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row (Supinated Grip)", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "triceps", default_exercise: "Triceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "biceps", default_exercise: "Biceps", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "bench_press" => {
      name: "Bench Press",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Bench Press", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "A2", category: "primary_pull", default_exercise: "Chin-Up (Neutral)", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "B1", category: "assistance_press", default_exercise: "Seated DB Press", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row (Pronated Grip)", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "scapular_retraction", default_exercise: "Scapular Retraction", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "dip" => {
      name: "Dip",
      slots: [
        { position: "A1", category: "primary_press", default_exercise: "Dip", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "A2", category: "primary_pull", default_exercise: "Pull-Up (Pronated)", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 90 },
        { position: "B1", category: "assistance_press", default_exercise: "Incline DB Press", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "assistance_pull", default_exercise: "Row (Neutral Grip)", sets: "3-4", reps: "6-10", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "external_rotation", default_exercise: "External Rotation", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "scapular_retraction", default_exercise: "Scapular Retraction", sets: "2-3", reps: "10-15", tempo: "3-0-1-0", rest: 30 }
      ]
    }
  }.freeze

  LOWER_BODY = {
    "squat_1" => {
      name: "Squat 1",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Back Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat or Lunge", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "knee_extension", default_exercise: "Leg Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "hip_extension", default_exercise: "Hip Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "squat_2" => {
      name: "Squat 2",
      slots: [
        { position: "A", category: "primary_squat", default_exercise: "Back Squat", sets: "4-6", reps: "1-12", tempo: "4-0-X-0", rest: 180 },
        { position: "B", category: "specialty_squat", default_exercise: "Specialty Squat", sets: "4-5", reps: "6-12", tempo: "3-0-1-0", rest: 150 },
        { position: "C1", category: "knee_extension", default_exercise: "Leg Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "hip_extension", default_exercise: "Hip Extension", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "front_squat" => {
      name: "Front Squat",
      slots: [
        { position: "A", category: "primary_front_squat", default_exercise: "Front Squat", sets: "4-6", reps: "1-6", tempo: "4-0-X-0", rest: 180 },
        { position: "B", category: "specialty_deadlift", default_exercise: "Specialty Deadlift", sets: "4-5", reps: "6-12", tempo: "3-0-1-0", rest: 150 },
        { position: "C1", category: "calves", default_exercise: "Calf Raise", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "abdominal", default_exercise: "Abs", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    },
    "deadlift" => {
      name: "Deadlift",
      slots: [
        { position: "A", category: "primary_deadlift", default_exercise: "Deadlift", sets: "4-6", reps: "1-6", tempo: "4-1-X-0", rest: 180 },
        { position: "B1", category: "split_stance", default_exercise: "Split Squat or Lunge", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "B2", category: "knee_flexion", default_exercise: "Leg Curl", sets: "3-4", reps: "6-12", tempo: "3-0-1-0", rest: 60 },
        { position: "C1", category: "calves", default_exercise: "Calf Raise", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 },
        { position: "C2", category: "abdominal", default_exercise: "Abs", sets: "2-3", reps: "10-20", tempo: "3-0-1-0", rest: 30 }
      ]
    }
  }.freeze

  ALL = UPPER_BODY.merge(LOWER_BODY).freeze

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
