class Mesocycle < ApplicationRecord
  belongs_to :macrocycle

  has_many :microcycles, dependent: :destroy

  enum :phase, { accumulation: 0, intensification: 1 }

  enum :loading_strategy, {
    constant: "constant",
    ascending: "ascending",
    descending: "descending",
    step: "step",
    peaking: "peaking",
    concentrated: "concentrated"
  }, prefix: true

  validates :phase, presence: true
  validates :number, presence: true

  # Returns the effective loading strategy, defaulting to :constant when nil.
  # Falls back to "constant" when the rep scheme is not standard sets (e.g. "8,8,6,6,4,4")
  # or the mesocycle is not 3 weeks.
  def effective_loading_strategy
    strategy = loading_strategy || "constant"
    return "constant" if strategy == "constant"
    return "constant" unless standard_sets?
    return "constant" unless microcycles.count == 3
    strategy
  end

  # Returns true if this mesocycle's A-series rep scheme is standard sets (e.g. "5x5", "4x10").
  # Non-standard schemes like "12,10,8,6" or "8,8,6,6,4,4" return false.
  def standard_sets?
    program = macrocycle&.program
    return true unless program&.periodization_model.present?

    seed_phase = Kilo::MacrocycleBuilder::PHASE_SEQUENCE[(number || 1) - 1]&.dig(:seed_phase)
    return true unless seed_phase

    record = KiloPeriodizationModel.find_by(
      model_id: program.periodization_model,
      macrocycle_number: program.macrocycle_number || 1,
      phase: seed_phase
    )
    return true unless record&.rep_scheme.present?

    record.rep_scheme.match?(/^\d+x\d+$/)
  end

  def prescribed_tonnage
    microcycles.sum(&:prescribed_tonnage)
  end

  def actual_tonnage
    microcycles.sum(&:actual_tonnage)
  end
end
