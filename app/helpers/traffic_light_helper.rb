
module TrafficLightHelper

  def pie_chart(traffic_lights, size=35)
     ("<canvas" +
        " class='pie'" +
        " data-red-count='#{count(traffic_lights,'red')}'" +
        " data-amber-count='#{count(traffic_lights,'amber')}'" +
        " data-green-count='#{count(traffic_lights,'green')}'" +
        " width='#{size}'" +
        " height='#{size}'>" +
      "</canvas>").html_safe
  end

  def diff_traffic_light(kata, avatar_name, light, max_lights)
    # used from test page and from dashboard page
    number = light['number'].to_i
    ("<div class='tipped diff-traffic-light'" +
         " data-id='#{kata.id}'" +
         " data-avatar-name='#{avatar_name}'" +
         " data-was-tag='#{number-1}'" +
         " data-now-tag='#{number}'" +
         " data-max-tag='#{max_lights}'>" +
        "<div class='tooltip'>" +
          tool_tip(avatar_name,light) +
        "</div>" +
        traffic_light_image(colour(light), 17, 54) +
     "</div>"
    ).html_safe
  end

  def colour(light)
     # old dojos used 'outcome'
     (light['colour'] || light['outcome']).to_s
  end

  def no_diff_avatar_image(kata, avatar_name, light, max_lights)
    ("<div class='tipped diff-traffic-light'" +
         " data-id='#{kata.id}'" +
         " data-avatar-name='#{avatar_name}'" +
         " data-was-tag='#{light['number']}'" +
         " data-now-tag='#{light['number']}'" +
         " data-max-tag='#{max_lights}'>" +
        "<div class='tooltip'>" +
          "review #{avatar_name}'s<br>" +
          "current code" +
        "</div>" +
        "<img src='/images/avatars/#{avatar_name}.jpg'" +
            " alt='#{avatar_name}'" +
            " title='#{avatar_name}'" +
            " width='45'" +
            " height='45'/>" +
     "</div>"
    ).html_safe
  end

  def traffic_light_image(colour, width, height)
    ("<img src='/images/traffic_light_#{colour}.png'" +
      " alt='#{colour} traffic-light'" +
      " width='#{width}'" +
      " height='#{height}'/>").html_safe
  end

  def tool_tip(avatar_name, light)
    n = light['number'].to_i
    "review #{avatar_name}'s<br>" +
    "#{n-1} &harr; #{n} diff"
  end

private

  def count(traffic_lights, colour)
     traffic_lights.count{|light| light['colour'] === colour}
  end

end
