# Builds the 12-week macrocycle structure based on limiting lifts and goal.
#
#   Input:  limiting_lift_upper, limiting_lift_lower, goal, model_id
#   Output: MacrocycleBlueprint (4 mesocycles with phase assignments)
#
#   Pipeline position: 4th (after periodization engine, before split selector)
#
#   Structure:
#     1 Macrocycle = 12 weeks = 4 Mesocycles
#     Each Mesocycle = 3 weeks (3 Microcycles)
#     Phase pattern: Acc1 → Int1 → Acc2 → Int2
#
#   The seed data phase names map to mesocycle positions:
#     Mesocycle 1 → accumulation
#     Mesocycle 2 → intensification
#     Mesocycle 3 → accumulation_2
#     Mesocycle 4 → intensification_2
#
class Kilo::MacrocycleBuilder
  # Maps mesocycle number → seed data phase key (for rep scheme lookup)
  # and display phase (for the mesocycle model enum)
  PHASE_SEQUENCE = [
    { seed_phase: :accumulation,      display_phase: :accumulation,      label: "Accumulation 1" },
    { seed_phase: :intensification,   display_phase: :intensification,   label: "Intensification 1" },
    { seed_phase: :accumulation_2,    display_phase: :accumulation,      label: "Accumulation 2" },
    { seed_phase: :intensification_2, display_phase: :intensification,   label: "Intensification 2" }
  ].freeze

  class MacrocycleBlueprint < Kilo::Result
    attr_reader :mesocycles, :limiting_lift_combo
  end

  class TemplateNotFound < StandardError; end

  def call(limiting_lift_upper:, limiting_lift_lower:, goal:, model_id:)
    combo = "#{limiting_lift_upper}_#{limiting_lift_lower}"

    # Look up macrocycle template for this limiting lift combination
    templates = KiloMacrocycleTemplate.where(limiting_lift_combo: combo)

    if templates.empty?
      templates = KiloMacrocycleTemplate.where(limiting_lift_combo: "balanced")
    end

    # Build 4 mesocycles
    mesocycles = PHASE_SEQUENCE.each_with_index.map do |phase_info, index|
      template = templates.find_by(phase: phase_info[:display_phase])

      {
        number: index + 1,
        phase: phase_info[:display_phase],       # For the Mesocycle model (accumulation/intensification)
        seed_phase: phase_info[:seed_phase],      # For rep scheme lookup in seed data
        label: phase_info[:label],
        weeks: 3,
        week_start: (index * 3) + 1,
        week_end: (index + 1) * 3,
        upper_sessions: template&.upper_sessions,
        lower_sessions: template&.lower_sessions
      }
    end

    result = MacrocycleBlueprint.new(
      mesocycles: mesocycles,
      limiting_lift_combo: combo
    )

    result.annotate(
      step: "macrocycle_structure",
      rule: "Limiting lift combo → macrocycle template",
      value: "#{limiting_lift_upper} (upper) + #{limiting_lift_lower} (lower)",
      decision: templates.any? ? "Found #{templates.count} phase templates for combo '#{combo}'" : "Using balanced template (no specific combo found)"
    )

    PHASE_SEQUENCE.each_with_index do |phase_info, i|
      is_acc = phase_info[:display_phase] == :accumulation
      result.annotate(
        step: "macrocycle_structure",
        rule: "Mesocycle #{i + 1}: #{phase_info[:label]}",
        value: "Weeks #{(i * 3) + 1}-#{(i + 1) * 3}",
        decision: "#{is_acc ? 'Higher volume, lower intensity' : 'Lower volume, higher intensity'}"
      )
    end

    result
  end
end
