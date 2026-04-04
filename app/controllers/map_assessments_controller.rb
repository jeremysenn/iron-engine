class MapAssessmentsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_assessment, only: %i[show]

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
      { key: "dip", name: "Dip", levels: 3 },
      { key: "chin_up", name: "Chin-Up", levels: 3 },
      { key: "overhead_press", name: "Overhead Press", levels: 3 },
      { key: "row", name: "Row", levels: 3 },
      { key: "push_up", name: "Push-Up", levels: 3 },
      { key: "external_rotation", name: "External Rotation", levels: 3 },
      { key: "trap_3_raise", name: "Trap 3 Raise", levels: 3 },
      { key: "prone_lateral_raise", name: "Prone Lateral Raise", levels: 3 }
    ]
  }.freeze

  def new
    @assessment = @client.map_assessments.build(assessed_at: Time.current)
    @patterns = MOVEMENT_PATTERNS
  end

  def create
    @assessment = @client.map_assessments.build(assessed_at: Time.current)

    if @assessment.save
      patterns_params.each do |key, attrs|
        attrs = attrs.symbolize_keys
        next if attrs[:level].blank? && attrs[:passed].blank?

        @assessment.map_progressions.create!(
          movement_pattern: key,
          level: attrs[:level].present? ? attrs[:level].to_i : 0,
          passed: attrs[:passed] == "1",
          exercise_name: attrs[:exercise_name]
        )
      end

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

  private

  def find_assessment
    @assessment = @client.map_assessments.find(params[:id])
  end

  def patterns_params
    params.fetch(:patterns, {}).permit!.to_h
  end
end
