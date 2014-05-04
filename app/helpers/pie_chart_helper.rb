
module PieChartHelper

  def pie_chart(traffic_lights, size, counts={})
     counts['red'] = tally(counts,traffic_lights,'red')
     counts['amber'] = tally(counts,traffic_lights,'amber')
     counts['green'] = tally(counts,traffic_lights,'green')
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

  def tally(counts, traffic_lights, colour)
     counts.include?(colour) ? counts[colour] : count(traffic_lights,colour)
  end

  def count(traffic_lights, colour)
     traffic_lights.count{|light| light['colour'] === colour}
  end

end
