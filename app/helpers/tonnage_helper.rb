module TonnageHelper
  def format_tonnage(value)
    return "0" if value.nil? || value.zero?
    number_with_delimiter(value.round)
  end

  def tonnage_badge(prescribed, actual = nil)
    parts = []
    parts << "Prescribed: #{format_tonnage(prescribed)}" if prescribed.to_f > 0
    parts << "Actual: #{format_tonnage(actual)}" if actual.to_f > 0
    parts.join(" / ")
  end
end
