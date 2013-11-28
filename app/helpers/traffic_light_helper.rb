
module TrafficLightHelper

  def diff_traffic_light(kata, avatar_name, light, max_lights)
    # used from test page and from dashboard page    
    ("<div class='tipped diff-traffic-light'" +
         " data-id='#{kata.id}'" +
         " data-avatar-name='#{avatar_name}'" +
         " data-was-tag='#{light[:number]-1}'" +
         " data-now-tag='#{light[:number]}'" +
         " data-max-tag='#{max_lights}'>" +
        "<div class='tooltip'>" +
          tool_tip(avatar_name,light) +
        "</div>" +
        traffic_light_image(light[:colour], 20, 62) +
     "</div>"
    ).html_safe    
  end

  def no_diff_avatar_image(kata, avatar_name, light, max_lights)
    ("<div class='tipped diff-traffic-light'" +
         " data-id='#{kata.id}'" +
         " data-avatar-name='#{avatar_name}'" +
         " data-was-tag='#{light[:number]}'" +
         " data-now-tag='#{light[:number]}'" +
         " data-max-tag='#{max_lights}'>" +
        "<div class='tooltip'>" +
          "Show #{avatar_name}'s<br>" +
          "current code" +
        "</div>" +
        "<img src='/images/avatars/#{avatar_name}.jpg'" +
            " alt='#{avatar_name}'" +
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
    n = light[:number]
    "Show #{avatar_name}'s diff<br>" +
    "#{n-1} &harr; #{n}<br>" +
    "(#{at(light)})"
  end
    
  def at(light)
    Time.mktime(*light[:time]).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
end
