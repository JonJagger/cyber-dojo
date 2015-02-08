
module PieChartHelper

  def pie_chart(traffic_lights, size, key)
     # key is often the traffic-light's avatar's name
     # but is 'zoo' for the collective-pie-chart of
     # all the animals
     pie_chart_from_counts({
        :red   => count(traffic_lights, :red),
        :amber => count(traffic_lights, :amber),
        :green => count(traffic_lights, :green),
        :timed_out => count(traffic_lights, :timed_out)
     }, size, key)
  end

  def pie_chart_from_counts(counts, size, key)
     "<canvas" +
        " class='pie'" +
        " data-tip='ajax:pie_chart'" +
        " data-red-count='#{counts[:red]}'" +
        " data-amber-count='#{counts[:amber]}'" +
        " data-green-count='#{counts[:green]}'" +
        " data-timed-out-count='#{counts[:timed_out]}'" +
        " data-key='#{key}'" +
        " width='#{size}'" +
        " height='#{size}'>" +
      "</canvas>"
  end

private

  def count(traffic_lights, colour)
     traffic_lights.entries.count{|light| light.colour === colour }
  end

end
