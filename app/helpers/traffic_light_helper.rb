
module TrafficLightHelper

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
        traffic_light_image(colour(light), 20, 62) +
     "</div>"
    ).html_safe    
  end

  def colour(light)
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
          "show #{avatar_name}'s<br>" +
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
    n = light['number'].to_i
    "review #{avatar_name}'s<br>" +
    "#{n-1} &harr; #{n} diff<br>" +
    "(#{at(light)})"
  end
    
  def at(light)
    Time.mktime(*light['time']).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - -
  
  def unlinked_traffic_light(inc, width = nil, height = nil)
    width ||= 20
    height ||= 62
    traffic_light_image(colour(inc),width,height)
  end
  
end
