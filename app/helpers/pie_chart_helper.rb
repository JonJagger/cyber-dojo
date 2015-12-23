
module PieChartHelper # mix-in

  module_function

  def pie_chart(lights, key)
     # key is the traffic-light's avatar's name
     pie_chart_from_counts({
              red: count(lights, :red),
            amber: count(lights, :amber),
            green: count(lights, :green),
        timed_out: count(lights, :timed_out)
     }, 34, key)
  end

  def pie_chart_from_counts(counts, size, key)
     '<canvas' +
        " class='pie'" +
        " data-red-count='#{counts[:red]}'" +
        " data-amber-count='#{counts[:amber]}'" +
        " data-green-count='#{counts[:green]}'" +
        " data-timed-out-count='#{counts[:timed_out]}'" +
        " data-key='#{key}'" +
        " width='#{size}'" +
        " height='#{size}'>" +
      '</canvas>'
  end

  def count(lights, colour)
    lights.entries.count { |light| light.colour == colour }
  end

end
