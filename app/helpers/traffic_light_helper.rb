
module TrafficLightHelper

  def linked_traffic_light(kata, avatar_name, inc, in_new_window)
    new_window = in_new_window ? { :target => '_blank' } : { }
    
    link_to unlinked_traffic_light(inc), 
    {   :controller => :diff, 
        :action => :show,
        :id => kata.id,
        :avatar => avatar_name,
        :tag => inc[:number] 
    }, 
    { :title => tool_tip(inc),
    }.merge(new_window)
  end
  
  def unlinked_traffic_light(inc)
    bulb = inc[:outcome].to_s
    ("<span title='#{at(inc)}'><img src='/images/traffic-light-#{bulb}.png'" +
      " border='0'" +
      " width='26'" +
      " height='78'/></span>").html_safe
  end
 
  def tool_tip(inc)
    "Show the diff of traffic-light ##{inc[:number]} (#{at(inc)})"
  end
    
  def at(inc)
    Time.mktime(*inc[:time]).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
end
