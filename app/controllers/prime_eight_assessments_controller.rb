class PrimeEightAssessmentsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_assessment, only: %i[show edit update]

  def new
    @assessment = @client.prime_eight_assessments.build(assessed_at: Time.current)
    @logged_hints = load_logged_hints
  end

  def create
    @assessment = @client.prime_eight_assessments.build(assessed_at: Time.current)

    if @assessment.save
      # Create lifts from params with pre-calculated E1RM
      lifts_params.each do |exercise, attrs|
        attrs = attrs.symbolize_keys
        next if attrs[:weight].blank?

        weight = attrs[:weight].to_f
        reps = (attrs[:reps].presence || 1).to_i

        # Pre-calculate E1RM so the record passes validation
        if reps == 1
          e1rm = weight
        elsif reps <= 20
          intensity = KiloRepIntensityTable.lookup(reps)
          e1rm = intensity ? (weight / (intensity / 100.0)).round(1) : weight
        else
          e1rm = (weight * (1 + 0.0333 * reps)).round(1)
        end

        @assessment.prime_eight_lifts.create!(
          exercise: exercise,
          weight: weight,
          reps: reps,
          e1rm: e1rm,
          formula_used: reps <= 20 ? :kilo_table : :epley
        )
      end

      # Run the ratio calculator (recalculates E1RMs and computes ratios)
      calculator = Kilo::StrengthRatioCalculator.new
      @ratio_result = calculator.call(@assessment.reload)

      # Persist ratio analyses
      @ratio_result.ratios.each do |exercise, data|
        data[:lift].create_strength_ratio_analysis!(
          current_ratio: data[:current_ratio],
          optimal_ratio: data[:optimal_ratio],
          discrepancy: data[:discrepancy],
          is_limiting: [exercise == @ratio_result.limiting_upper, exercise == @ratio_result.limiting_lower].any?
        )
      end

      redirect_to client_prime_eight_assessment_path(@client, @assessment), notice: "Assessment complete. Ratios calculated."
    else
      render :new, status: :unprocessable_entity
    end
  rescue Kilo::StrengthRatioCalculator::MissingBaselineError, Kilo::StrengthRatioCalculator::InsufficientDataError => e
    @assessment.destroy if @assessment.persisted?
    flash.now[:alert] = e.message
    @assessment = @client.prime_eight_assessments.build(assessed_at: Time.current)
    render :new, status: :unprocessable_entity
  end

  def show
    @lifts = @assessment.prime_eight_lifts.includes(:strength_ratio_analysis)
    @ratio_result = build_ratio_display(@lifts)
  end

  def edit
    @existing_lifts = @assessment.prime_eight_lifts.index_by { |l| l.exercise.to_sym }
  end

  def update
    ActiveRecord::Base.transaction do
      # Clear existing lifts and ratio analyses
      @assessment.prime_eight_lifts.destroy_all

      # Recreate lifts from params
      lifts_params.each do |exercise, attrs|
        attrs = attrs.symbolize_keys
        next if attrs[:weight].blank?

        weight = attrs[:weight].to_f
        reps = (attrs[:reps].presence || 1).to_i

        if reps == 1
          e1rm = weight
        elsif reps <= 20
          intensity = KiloRepIntensityTable.lookup(reps)
          e1rm = intensity ? (weight / (intensity / 100.0)).round(1) : weight
        else
          e1rm = (weight * (1 + 0.0333 * reps)).round(1)
        end

        @assessment.prime_eight_lifts.create!(
          exercise: exercise,
          weight: weight,
          reps: reps,
          e1rm: e1rm,
          formula_used: reps <= 20 ? :kilo_table : :epley
        )
      end

      # Recalculate ratios
      calculator = Kilo::StrengthRatioCalculator.new
      @ratio_result = calculator.call(@assessment.reload)

      @ratio_result.ratios.each do |exercise, data|
        data[:lift].create_strength_ratio_analysis!(
          current_ratio: data[:current_ratio],
          optimal_ratio: data[:optimal_ratio],
          discrepancy: data[:discrepancy],
          is_limiting: [exercise == @ratio_result.limiting_upper, exercise == @ratio_result.limiting_lower].any?
        )
      end
    end

    redirect_to client_prime_eight_assessment_path(@client, @assessment), notice: "Assessment updated. Ratios recalculated."
  rescue Kilo::StrengthRatioCalculator::MissingBaselineError, Kilo::StrengthRatioCalculator::InsufficientDataError => e
    flash.now[:alert] = e.message
    @existing_lifts = @assessment.reload.prime_eight_lifts.index_by { |l| l.exercise.to_sym }
    render :edit, status: :unprocessable_entity
  end

  private

  def find_assessment
    @assessment = @client.prime_eight_assessments.find(params[:id])
  end

  def lifts_params
    params.require(:lifts).permit(
      squat: %i[weight reps], front_squat: %i[weight reps], deadlift: %i[weight reps],
      bench_press: %i[weight reps], overhead_press: %i[weight reps],
      incline_press: %i[weight reps], dip: %i[weight reps], chin_up: %i[weight reps]
    ).to_h.symbolize_keys
  end

  def build_ratio_display(lifts)
    lifts.each_with_object({}) do |lift, hash|
      analysis = lift.strength_ratio_analysis
      next unless analysis

      hash[lift.exercise.to_sym] = {
        e1rm: lift.e1rm.to_f,
        current_ratio: analysis.current_ratio.to_f,
        optimal_ratio: analysis.optimal_ratio.to_f,
        discrepancy: analysis.discrepancy.to_f,
        is_limiting: analysis.is_limiting?,
        body_region: KiloOptimalRatio.find_by(exercise: lift.exercise)&.body_region
      }
    end
  end

  # Finds the most recent logged performance for each PrimeEight exercise
  # by searching across all of the client's workout history.
  PRIME_EIGHT_SEARCH = {
    squat: "Squat",
    front_squat: "Front Squat%",
    deadlift: "Deadlift",
    bench_press: "Bench Press%",
    overhead_press: "Overhead Press%",
    incline_press: "Incline Press%",
    dip: "Dip%",
    chin_up: "Chin-Up%"
  }.freeze

  def load_logged_hints
    hints = {}

    PRIME_EIGHT_SEARCH.each do |exercise_key, name_pattern|
      set = ExerciseSet
        .joins(session_exercise: { training_session: { microcycle: { mesocycle: { macrocycle: :program } } } })
        .includes(session_exercise: :training_session)
        .where(programs: { client_id: @client.id })
        .where.not(actual_weight: nil).where.not(actual_reps: nil)
        .where("exercise_sets.actual_weight > 0")
        .where("exercise_sets.actual_reps > 0")
        .where("session_exercises.exercise_name LIKE ?", name_pattern)
        .order(
          Arel.sql("COALESCE(training_sessions.completed_at, training_sessions.created_at::date) DESC"),
          "exercise_sets.actual_weight DESC"
        ).first

      next unless set

      weight = set.actual_weight.to_f
      reps = set.actual_reps.to_i
      session = set.session_exercise.training_session
      logged_date = session.completed_at || session.created_at.to_date

      if reps == 1
        e1rm = weight
      elsif reps <= 20
        intensity = KiloRepIntensityTable.lookup(reps)
        e1rm = intensity ? (weight / (intensity / 100.0)).round(1) : weight
      else
        e1rm = (weight * (1 + 0.0333 * reps)).round(1)
      end

      hints[exercise_key] = { weight: weight, reps: reps, e1rm: e1rm, date: logged_date }
    end

    hints
  end
end
