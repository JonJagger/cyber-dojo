
module TrafficLightHelper

  def revert_traffic_light(inc)
    bulb = inc[:colour].to_s
    ("<span title='Revert to traffic-light #{inc[:number]} (#{bulb})'>" +
     untitled_unlinked_traffic_light(inc) +
     "</span>").html_safe
  end
  
  def linked_traffic_light(kata, avatar_name, inc, in_new_window)
    new_window = in_new_window ? { :target => '_blank' } : { }
    
    link_to untitled_unlinked_traffic_light(inc), 
    {   :controller => :diff, 
        :action => :show,
        :id => kata.id,
        :avatar => avatar_name,
        :was_tag => inc[:number]-1,
        :now_tag => inc[:number] 
    }, 
    { :title => tool_tip(avatar_name,inc),
    }.merge(new_window)
  end
  
  def untitled_unlinked_traffic_light(inc, width = nil, height = nil)
    width ||= 20
    height ||= 65
    bulb = inc[:colour].to_s
    ("<img src='/images/traffic_light_#{bulb}.png'" +
      " border='0'" +
      " width='#{width}'" +
      " height='#{height}'/>").html_safe    
  end
  
  def unlinked_traffic_light(inc, width = nil, height = nil)
    bulb = inc[:colour].to_s
    ("<span title='#{at(inc)}'>" +
     untitled_unlinked_traffic_light(inc, width, height) +
     "</span>").html_safe
  end
 
  def tool_tip(avatar_name,inc)
    "Show the diff of " + avatar_name + " traffic-light ##{inc[:number]} (#{at(inc)})"
  end
    
  def at(inc)
    Time.mktime(*inc[:time]).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
end
