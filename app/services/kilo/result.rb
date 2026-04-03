# Base class for all KILO service return values.
# Each service returns a typed Result subclass with an annotations array
# for "Show Your Work" mode.
#
#   Pipeline:
#   ┌──────────┐    ┌──────────┐    ┌──────────┐
#   │ Service  │───▶│  Result  │───▶│ Service  │───▶ ...
#   │  #call   │    │ (PORO)   │    │  #call   │
#   └──────────┘    │ .annotations│  └──────────┘
#                   └──────────┘
#
class Kilo::Result
  attr_reader :annotations

  def initialize(**attrs)
    @annotations = []
    attrs.each do |key, value|
      instance_variable_set(:"@#{key}", value)
      self.class.attr_reader(key) unless respond_to?(key)
    end
  end

  def annotate(step:, rule:, value:, decision:)
    @annotations << { step: step, rule: rule, value: value, decision: decision }
    self
  end
end
