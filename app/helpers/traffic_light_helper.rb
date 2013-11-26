
module TrafficLightHelper

  def diff_traffic_light(kata, avatar_name, light, max_lights)    
    ("<span class='diff-traffic-light'" +
          ' title="' + tool_tip(avatar_name,light) + '"' +
          " data-id='#{kata.id}'" +
          " data-avatar-name='#{avatar_name}'" +
          " data-was-tag='#{light[:number]-1}'" +
          " data-now-tag='#{light[:number]}'" +
          " data-max-tag='#{max_lights}'>" +
        traffic_light_image(light[:colour], 20, 62) +
     "</span>"
    ).html_safe    
  end

  def no_diff_avatar_image(kata, avatar_name, light, max_lights)
    ("<span class='diff-traffic-light'" +
          ' title="' + "Show #{avatar_name}'s current code" + '"' +
          " data-id='#{kata.id}'" +
          " data-avatar-name='#{avatar_name}'" +
          " data-was-tag='#{light[:number]}'" +
          " data-now-tag='#{light[:number]}'" +
          " data-max-tag='#{max_lights}'>" +
      "<img src='/images/avatars/#{avatar_name}.jpg'" +
          " alt='#{avatar_name}'" +
          " width='45'" +
          " height='45'/>" +           
     "</span>"
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
    "Show #{avatar_name}'s diff #{n-1} <-> #{n} (#{at(light)})"
  end
    
  def at(light)
    Time.mktime(*light[:time]).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
end
