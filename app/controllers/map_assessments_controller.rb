class MapAssessmentsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_assessment, only: %i[show edit update]

  MOVEMENT_PATTERNS = {
    lower_body: [
      { key: "trunk_stability", name: "Trunk Stability", levels: 0, test: "Plank - Front" },
      { key: "squat", name: "Squat", levels: 4 },
      { key: "deadlift", name: "Deadlift", levels: 3 },
      { key: "split_squat", name: "Split Squat", levels: 3 },
      { key: "seated_goodmorning", name: "Seated Goodmorning", levels: 3 },
      { key: "step_up", name: "Step-Up", levels: 3 },
      { key: "ankle_dorsiflexion", name: "Ankle Dorsiflexion", levels: 0, test: "Weight Bearing Lunge" }
    ],
    upper_body: [
      { key: "dip", name: "Dip", levels: 0, test: "Dip",
        fail_types: [ [ "rom", "Fail - ROM" ], [ "scapular", "Fail - Scapular" ] ] },
      { key: "chin_up", name: "Chin-Up", levels: 0, test: "Chin-Up - Medium Grip - Semi-Supinated" },
      { key: "overhead_press", name: "Overhead Press", levels: 3 },
      { key: "row", name: "Row", levels: 3 },
      { key: "push_up", name: "Push-Up", levels: 3 },
      { key: "external_rotation", name: "External Rotation", levels: 0, test: "External Rotation - Seated - Arm at 45°",
        fail_types: [ [ "external_rom", "Fail - External Rotation ROM" ], [ "internal_rom", "Fail - Internal Rotation ROM" ], [ "both_rom", "Fail - External and Internal Rotation ROM" ] ] },
      { key: "trap_3_raise", name: "Trap 3 Raise", levels: 0, test: "Trap 3 Raise - Prone - 15° Incline - One-Arm" },
      { key: "prone_lateral_raise", name: "Prone Lateral Raise", levels: 0, test: "Lateral Raise - Prone - 15° Incline - Neutral - One-Arm" }
    ]
  }.freeze

  def new
    @assessment = @client.map_assessments.build(assessed_at: Time.current)
    @patterns = MOVEMENT_PATTERNS
  end

  def create
    @assessment = @client.map_assessments.build(assessed_at: Time.current)

    if @assessment.save
      save_progressions(@assessment)

      # Run MAP engine
      engine = Kilo::MapAssessmentEngine.new
      @result = engine.call(@assessment.reload)

      redirect_to client_map_assessment_path(@client, @assessment),
        notice: "MAP Assessment saved. #{@assessment.map_progressions.count} patterns recorded."
    else
      @patterns = MOVEMENT_PATTERNS
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @progressions = @assessment.map_progressions.order(:movement_pattern)
    @patterns = MOVEMENT_PATTERNS
    @complete = @assessment.complete?
  end

  def edit
    @progressions_by_key = @assessment.map_progressions.index_by(&:movement_pattern)
    @patterns = MOVEMENT_PATTERNS
  end

  def update
    @assessment.map_progressions.destroy_all
    save_progressions(@assessment)

    # Re-run MAP engine
    engine = Kilo::MapAssessmentEngine.new
    engine.call(@assessment.reload)

    redirect_to client_map_assessment_path(@client, @assessment),
      notice: "MAP Assessment updated. #{@assessment.map_progressions.count} patterns recorded."
  end

  private

  def find_assessment
    @assessment = @client.map_assessments.find(params[:id])
  end

  def patterns_params
    raw = params.fetch(:patterns, {})
    raw.to_unsafe_h.transform_values { |v| v.slice(:level, :passed) }
  end

  # Parses form params and creates map_progressions.
  # Handles three input types:
  #   - Leveled patterns: level dropdown + pass checkbox (passed = "0" or "1")
  #   - Fail-type patterns: dropdown with "1" (pass), "fail_rom", "fail_scapular", etc.
  #   - Simple pass/fail: checkbox (passed = "0" or "1")
  def save_progressions(assessment)
    patterns_params.each do |key, attrs|
      attrs = attrs.symbolize_keys
      passed_val = attrs[:passed].to_s

      # Skip if not tested
      next if passed_val.blank? && attrs[:level].blank?
      next if passed_val == "" # "Not tested" selected in fail_type dropdown

      # Determine passed/fail and optional fail type
      if passed_val.start_with?("fail_")
        passed = false
        fail_type = passed_val.delete_prefix("fail_")
      else
        passed = passed_val == "1"
        fail_type = nil
      end

      assessment.map_progressions.create!(
        movement_pattern: key,
        level: attrs[:level].present? ? attrs[:level].to_i : 0,
        passed: passed,
        exercise_name: fail_type
      )
    end
  end
end
