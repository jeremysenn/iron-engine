module RadarChartHelper
  # Generates an SVG radar chart comparing current vs optimal strength ratios.
  #
  #   exercises: { exercise_name: { current_ratio:, optimal_ratio:, is_limiting: } }
  #   size: pixel dimensions (square)
  #
  # Optimal ratios shown as dashed outline, actual as filled polygon.
  # Limiting lift point highlighted in red.
  #
  LABEL_SHORT = {
    squat: "SQ", front_squat: "FS", deadlift: "DL",
    bench_press: "BP", overhead_press: "OHP", incline_press: "INC",
    dip: "DIP", chin_up: "CU"
  }.freeze

  def radar_chart_svg(exercises, size: 300)
    return "" if exercises.empty?

    cx = size / 2.0
    cy = size / 2.0
    radius = size * 0.30
    label_radius = size * 0.43
    n = exercises.size
    entries = exercises.to_a

    # Calculate points for a regular polygon
    points_for = ->(values_hash, scale_key, max_val) {
      entries.each_with_index.map do |(name, data), i|
        angle = (2 * Math::PI * i / n) - (Math::PI / 2)
        val = data[scale_key].to_f
        r = (val / max_val) * radius
        [(cx + r * Math.cos(angle)).round(1), (cy + r * Math.sin(angle)).round(1)]
      end
    }

    # Find the maximum ratio value for scaling
    max_val = entries.map { |_, d| [d[:current_ratio].to_f, d[:optimal_ratio].to_f].max }.max
    max_val = [max_val, 130].max # At least 130% for deadlift scale

    optimal_points = points_for.call(entries, :optimal_ratio, max_val)
    actual_points = points_for.call(entries, :current_ratio, max_val)

    # Grid rings at 25%, 50%, 75%, 100% of max
    grid_rings = [0.25, 0.5, 0.75, 1.0].map do |pct|
      r = pct * radius
      entries.each_with_index.map do |(_, _), i|
        angle = (2 * Math::PI * i / n) - (Math::PI / 2)
        [(cx + r * Math.cos(angle)).round(1), (cy + r * Math.sin(angle)).round(1)]
      end
    end

    # Grid lines from center to each vertex
    axis_endpoints = entries.each_with_index.map do |(_, _), i|
      angle = (2 * Math::PI * i / n) - (Math::PI / 2)
      [(cx + radius * Math.cos(angle)).round(1), (cy + radius * Math.sin(angle)).round(1)]
    end

    # Label positions
    labels = entries.each_with_index.map do |(name, data), i|
      angle = (2 * Math::PI * i / n) - (Math::PI / 2)
      lx = (cx + label_radius * Math.cos(angle)).round(1)
      ly = (cy + label_radius * Math.sin(angle)).round(1)

      # Text anchor based on position
      anchor = if Math.cos(angle).abs < 0.1
        "middle"
      elsif Math.cos(angle) > 0
        "start"
      else
        "end"
      end

      { name: name, ratio: data[:current_ratio].to_f, is_limiting: data[:is_limiting],
        x: lx, y: ly, anchor: anchor }
    end

    content_tag(:svg, width: size, height: size, viewBox: "0 0 #{size} #{size}",
                class: "inline-block") do
      parts = []

      # Grid rings
      grid_rings.each_with_index do |ring, ri|
        pts = ring.map { |p| p.join(",") }.join(" ")
        parts << tag.polygon(points: pts, fill: "none", stroke: "#e2e8f0",
                             stroke_width: ri == 3 ? 1.5 : 0.5, opacity: ri == 3 ? 0.6 : 0.3)
      end

      # Axis lines
      axis_endpoints.each do |ep|
        parts << tag.line(x1: cx, y1: cy, x2: ep[0], y2: ep[1],
                          stroke: "#e2e8f0", stroke_width: 0.5, opacity: 0.3)
      end

      # Optimal polygon (dashed)
      opt_pts = optimal_points.map { |p| p.join(",") }.join(" ")
      parts << tag.polygon(points: opt_pts, fill: "#0d9488", fill_opacity: 0.08,
                           stroke: "#0d9488", stroke_width: 1.5, stroke_dasharray: "4")

      # Actual polygon (filled)
      act_pts = actual_points.map { |p| p.join(",") }.join(" ")
      parts << tag.polygon(points: act_pts, fill: "#0d9488", fill_opacity: 0.2,
                           stroke: "#0d9488", stroke_width: 2)

      # Data points
      actual_points.each_with_index do |pt, i|
        is_lim = entries[i][1][:is_limiting]
        parts << tag.circle(cx: pt[0], cy: pt[1], r: is_lim ? 5 : 3.5,
                            fill: is_lim ? "#dc2626" : "#0d9488",
                            stroke: "white", stroke_width: is_lim ? 2 : 1.5)
      end

      # Labels (short name + ratio on two lines)
      labels.each do |lbl|
        color = lbl[:is_limiting] ? "#dc2626" : "#64748b"
        short = LABEL_SHORT[lbl[:name]] || lbl[:name].to_s.titleize
        parts << content_tag(:text, nil, x: lbl[:x], y: lbl[:y],
                             text_anchor: lbl[:anchor], fill: color,
                             font_family: "'JetBrains Mono', monospace",
                             font_size: 11, font_weight: lbl[:is_limiting] ? 600 : 400) do
          safe_join([
            content_tag(:tspan, short, x: lbl[:x], dy: 0),
            content_tag(:tspan, "#{lbl[:ratio].round(0)}%", x: lbl[:x], dy: 13, font_size: 10, fill: color)
          ])
        end
      end

      safe_join(parts)
    end
  end
end
