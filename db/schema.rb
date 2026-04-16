# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_16_140000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "client_share_tokens", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "revoked_at"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_share_tokens_on_client_id"
    t.index ["token"], name: "index_client_share_tokens_on_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "first_name"
    t.string "last_name"
    t.text "notes"
    t.integer "training_age"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "exercise_sets", force: :cascade do |t|
    t.integer "actual_reps"
    t.decimal "actual_weight"
    t.datetime "created_at", null: false
    t.bigint "session_exercise_id", null: false
    t.integer "set_number"
    t.integer "target_reps"
    t.decimal "target_weight"
    t.datetime "updated_at", null: false
    t.index ["session_exercise_id"], name: "index_exercise_sets_on_session_exercise_id"
  end

  create_table "kilo_exercise_pairings", force: :cascade do |t|
    t.integer "context"
    t.datetime "created_at", null: false
    t.bigint "paired_exercise_id", null: false
    t.bigint "primary_exercise_id", null: false
    t.datetime "updated_at", null: false
    t.index ["paired_exercise_id"], name: "index_kilo_exercise_pairings_on_paired_exercise_id"
    t.index ["primary_exercise_id"], name: "index_kilo_exercise_pairings_on_primary_exercise_id"
  end

  create_table "kilo_exercises", force: :cascade do |t|
    t.string "body_region"
    t.string "category"
    t.datetime "created_at", null: false
    t.boolean "custom", default: false, null: false
    t.string "equipment"
    t.string "grip_type"
    t.string "grip_width"
    t.string "name"
    t.integer "progression_order"
    t.integer "rotation_group"
    t.string "subcategory"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "video_url"
    t.index ["user_id"], name: "index_kilo_exercises_on_user_id"
  end

  create_table "kilo_macrocycle_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "limiting_lift_combo"
    t.jsonb "lower_sessions"
    t.integer "phase"
    t.datetime "updated_at", null: false
    t.jsonb "upper_sessions"
  end

  create_table "kilo_optimal_ratios", force: :cascade do |t|
    t.integer "body_region"
    t.datetime "created_at", null: false
    t.integer "exercise"
    t.decimal "ratio_pct"
    t.datetime "updated_at", null: false
  end

  create_table "kilo_periodization_models", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "intensity_pct"
    t.integer "macrocycle_number"
    t.string "model_id"
    t.integer "phase"
    t.string "rep_scheme"
    t.datetime "updated_at", null: false
    t.index ["model_id", "macrocycle_number", "phase"], name: "idx_kilo_period_model_macro_phase", unique: true
  end

  create_table "kilo_rep_intensity_tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "intensity_pct"
    t.integer "reps"
    t.datetime "updated_at", null: false
    t.index ["reps"], name: "index_kilo_rep_intensity_tables_on_reps", unique: true
  end

  create_table "kilo_rep_schemes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "intensity_pct"
    t.string "rep_pattern"
    t.string "strength_quality"
    t.integer "total_reps"
    t.datetime "updated_at", null: false
  end

  create_table "kilo_training_methods", force: :cascade do |t|
    t.integer "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "tempo"
    t.datetime "updated_at", null: false
  end

  create_table "kilo_training_splits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "frequency"
    t.integer "goal"
    t.string "name"
    t.integer "phase"
    t.jsonb "split_structure"
    t.integer "training_level"
    t.datetime "updated_at", null: false
  end

  create_table "macrocycles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "goal_focus"
    t.integer "number"
    t.bigint "program_id", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_macrocycles_on_program_id"
  end

  create_table "map_assessments", force: :cascade do |t|
    t.datetime "assessed_at"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_map_assessments_on_client_id"
  end

  create_table "map_progressions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "exercise_name"
    t.integer "level"
    t.bigint "map_assessment_id", null: false
    t.string "movement_pattern"
    t.boolean "passed"
    t.datetime "updated_at", null: false
    t.index ["map_assessment_id"], name: "index_map_progressions_on_map_assessment_id"
  end

  create_table "mesocycles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "loading_strategy"
    t.bigint "macrocycle_id", null: false
    t.integer "number"
    t.integer "phase"
    t.datetime "updated_at", null: false
    t.index ["macrocycle_id"], name: "index_mesocycles_on_macrocycle_id"
  end

  create_table "microcycles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "mesocycle_id", null: false
    t.datetime "updated_at", null: false
    t.integer "week_number"
    t.index ["mesocycle_id"], name: "index_microcycles_on_mesocycle_id"
  end

  create_table "prime_eight_assessments", force: :cascade do |t|
    t.datetime "assessed_at"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_prime_eight_assessments_on_client_id"
  end

  create_table "prime_eight_lifts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "e1rm"
    t.integer "exercise"
    t.integer "formula_used"
    t.bigint "prime_eight_assessment_id", null: false
    t.integer "reps"
    t.datetime "updated_at", null: false
    t.decimal "weight"
    t.index ["prime_eight_assessment_id"], name: "index_prime_eight_lifts_on_prime_eight_assessment_id"
  end

  create_table "programs", force: :cascade do |t|
    t.datetime "archived_at"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.integer "frequency"
    t.jsonb "generation_metadata"
    t.integer "goal"
    t.integer "limiting_lift_lower"
    t.integer "limiting_lift_upper"
    t.integer "macrocycle_number", default: 1, null: false
    t.string "periodization_model"
    t.string "split_type"
    t.integer "status"
    t.integer "training_level"
    t.datetime "updated_at", null: false
    t.integer "volume"
    t.index ["client_id"], name: "index_programs_on_client_id"
    t.index ["client_id"], name: "index_programs_one_active_per_client", unique: true, where: "(status = 0)"
  end

  create_table "session_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "exercise_name"
    t.string "group"
    t.integer "group_type"
    t.bigint "kilo_exercise_id"
    t.boolean "map_adjusted", default: false, null: false
    t.string "position"
    t.integer "rest_seconds"
    t.integer "sets"
    t.string "tempo"
    t.bigint "training_session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["kilo_exercise_id"], name: "index_session_exercises_on_kilo_exercise_id"
    t.index ["training_session_id"], name: "index_session_exercises_on_training_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "strength_ratio_analyses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "current_ratio"
    t.decimal "discrepancy"
    t.boolean "is_limiting"
    t.decimal "optimal_ratio"
    t.bigint "prime_eight_lift_id", null: false
    t.datetime "updated_at", null: false
    t.index ["prime_eight_lift_id"], name: "index_strength_ratio_analyses_on_prime_eight_lift_id"
  end

  create_table "training_sessions", force: :cascade do |t|
    t.date "completed_at"
    t.datetime "created_at", null: false
    t.integer "day"
    t.bigint "microcycle_id", null: false
    t.integer "session_type"
    t.datetime "updated_at", null: false
    t.index ["microcycle_id"], name: "index_training_sessions_on_microcycle_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "client_share_tokens", "clients"
  add_foreign_key "clients", "users"
  add_foreign_key "exercise_sets", "session_exercises"
  add_foreign_key "kilo_exercise_pairings", "kilo_exercises", column: "paired_exercise_id"
  add_foreign_key "kilo_exercise_pairings", "kilo_exercises", column: "primary_exercise_id"
  add_foreign_key "kilo_exercises", "users"
  add_foreign_key "macrocycles", "programs"
  add_foreign_key "map_assessments", "clients"
  add_foreign_key "map_progressions", "map_assessments"
  add_foreign_key "mesocycles", "macrocycles"
  add_foreign_key "microcycles", "mesocycles"
  add_foreign_key "prime_eight_assessments", "clients"
  add_foreign_key "prime_eight_lifts", "prime_eight_assessments"
  add_foreign_key "programs", "clients"
  add_foreign_key "session_exercises", "kilo_exercises"
  add_foreign_key "session_exercises", "training_sessions"
  add_foreign_key "sessions", "users"
  add_foreign_key "strength_ratio_analyses", "prime_eight_lifts"
  add_foreign_key "training_sessions", "microcycles"
end
