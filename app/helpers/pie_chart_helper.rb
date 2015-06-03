
module PieChartHelper

  def pie_chart(lights, key)
     # key is often the traffic-light's avatar's name
     # but is 'zoo' for the collective-pie-chart of
     # all the animals
     pie_chart_from_counts({
        :red   => count(lights, :red),
        :amber => count(lights, :amber),
        :green => count(lights, :green),
        :timed_out => count(lights, :timed_out)
     }, 27, key)
  end

  def pie_chart_from_counts(counts, size, key)
     "<canvas" +
        " class='pie'" +
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

  def count(lights, colour)
     lights.entries.count{|light| light.colour === colour }
  end

end
