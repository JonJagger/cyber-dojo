
module TrafficLightHelper

  def linked_traffic_light(kata, avatar_name, inc, in_new_window)
    new_window = in_new_window ? { :target => '_blank' } : { }
    
    link_to untitled_unlinked_traffic_light(inc), 
    {   :controller => :diff, 
        :action => :show,
        :id => kata.id,
        :avatar => avatar_name,
        :tag => inc[:number] 
    }, 
    { :title => tool_tip(inc),
    }.merge(new_window)
  end
  
  def untitled_unlinked_traffic_light(inc)
    bulb = inc[:outcome].to_s
    ("<img src='/images/traffic_light_#{bulb}.png'" +
      " border='0'" +
      " width='22'" +
      " height='65'/>").html_safe    
  end
  
  def unlinked_traffic_light(inc)
    bulb = inc[:outcome].to_s
    ("<span title='#{at(inc)}'>" +
     untitled_unlinked_traffic_light(inc) +
     "</span>").html_safe
  end
 
  def tool_tip(inc)
    "Show the diff of traffic-light ##{inc[:number]} (#{at(inc)})"
  end
    
  def at(inc)
    Time.mktime(*inc[:time]).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
end
