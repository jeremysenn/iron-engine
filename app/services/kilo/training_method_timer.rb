# Assigns training methods to phases based on goal and training level.
#
#   Input:  phase, goal, training_level
#   Output: MethodBlueprint (list of training methods for this phase)
#
#   Pipeline position: 6th (after split selector, before session generator)
#
#   Training methods by category:
#     Concentric:  IMCA, Speed-Strength
#     Eccentric:   Sub-Maximal, Supra-Maximal
#     Isometric:   Yielding, Overcoming
#
#   General timing rules:
#     Accumulation phases: concentric methods (IMCA), yielding isometrics
#     Intensification phases: eccentric methods, overcoming isometrics, speed-strength
#
class Kilo::TrainingMethodTimer
  class MethodBlueprint < Kilo::Result
    attr_reader :methods
  end

  def call(phase:, goal:, training_level:)
    phase = phase.to_sym

    # Select methods appropriate for this phase
    methods = if phase == :accumulation
      KiloTrainingMethod.where(category: [ :concentric, :isometric ])
    else
      KiloTrainingMethod.where(category: [ :eccentric, :isometric, :concentric ])
    end

    # If no seed data yet, return empty with annotation
    method_list = methods.to_a

    result = MethodBlueprint.new(methods: method_list)

    result.annotate(
      step: "training_method_timing",
      rule: "Phase → training method categories",
      value: "#{phase} phase, #{goal} goal, #{training_level} level",
      decision: if method_list.any?
        "Assigned #{method_list.size} methods: #{method_list.map(&:name).join(', ')}"
                else
        "No training methods seeded yet. Methods will use defaults."
                end
    )

    result
  end
end
