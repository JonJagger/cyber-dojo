
module PieChartHelper

  def pie_chart(traffic_lights, size)
     pie_chart_from_counts({
        'red'   => count(traffic_lights,'red'),
        'amber' => count(traffic_lights,'amber'),
        'green' => count(traffic_lights,'green')
     }, size)
  end

  def pie_chart_from_counts(counts, size)
     ("<canvas" +
        " class='pie'" +
        " data-red-count='#{counts['red']}'" +
        " data-amber-count='#{counts['amber']}'" +
        " data-green-count='#{counts['green']}'" +
        " width='#{size}'" +
        " height='#{size}'>" +
      "</canvas>").html_safe
  end

private

  def XXXtally(counts, traffic_lights, colour)
     counts.include?(colour) ? counts[colour] : count(traffic_lights,colour)
  end

  def count(traffic_lights, colour)
     traffic_lights.count{|light| light['colour'] === colour}
  end

end
