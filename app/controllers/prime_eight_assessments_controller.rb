class PrimeEightAssessmentsController < ApplicationController
  include Scopeable

  before_action :find_client
  before_action :find_assessment, only: %i[show]

  def new
    @assessment = @client.prime_eight_assessments.build(assessed_at: Time.current)
  end

  def create
    @assessment = @client.prime_eight_assessments.build(assessed_at: Time.current)

    if @assessment.save
      # Create lifts from params
      lifts_params.each do |exercise, attrs|
        next if attrs[:weight].blank?

        @assessment.prime_eight_lifts.create!(
          exercise: exercise,
          weight: attrs[:weight],
          reps: attrs[:reps].presence || 1,
          e1rm: 0, # Will be calculated by the service
          formula_used: :kilo_table
        )
      end

      # Run the ratio calculator
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
end
