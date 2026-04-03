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
class Kilo::MacrocycleBuilder
  PHASE_PATTERN = %i[accumulation intensification accumulation intensification].freeze

  class MacrocycleBlueprint < Kilo::Result
    attr_reader :mesocycles, :limiting_lift_combo
  end

  class TemplateNotFound < StandardError; end

  def call(limiting_lift_upper:, limiting_lift_lower:, goal:, model_id:)
    combo = "#{limiting_lift_upper}_#{limiting_lift_lower}"

    # Look up macrocycle template for this limiting lift combination
    templates = KiloMacrocycleTemplate.where(limiting_lift_combo: combo)

    if templates.empty?
      # Try balanced template if no specific combo exists
      templates = KiloMacrocycleTemplate.where(limiting_lift_combo: "balanced")
    end

    # Build 4 mesocycles with the standard phase pattern
    mesocycles = PHASE_PATTERN.each_with_index.map do |phase, index|
      template = templates.find_by(phase: phase)

      {
        number: index + 1,
        phase: phase,
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

    PHASE_PATTERN.each_with_index do |phase, i|
      result.annotate(
        step: "macrocycle_structure",
        rule: "Mesocycle #{i + 1} phase assignment",
        value: "Weeks #{(i * 3) + 1}-#{(i + 1) * 3}",
        decision: "#{phase} phase (#{phase == :accumulation ? 'higher volume, lower intensity' : 'lower volume, higher intensity'})"
      )
    end

    result
  end
end
