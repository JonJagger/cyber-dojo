
module TrafficLightHelper

  def linked_traffic_light(kata, avatar_name, inc, in_new_window)
    minutes = duration_in_minutes(kata.created, Time.mktime(*inc[:time]))
    new_window = in_new_window ? { :target => '_blank' } : { }
    
    link_to unlinked_traffic_light(inc), 
    {   :controller => :diff, 
        :action => :show,
        :id => kata.id,
        :avatar => avatar_name,
        :tag => inc[:number] 
    }, 
    { :title => tool_tip(inc[:number]),
    }.merge(new_window)
  end
  
  def unlinked_traffic_light(inc)
    bulb = 'red'   if inc[:outcome] == :failed
    bulb = 'amber' if inc[:outcome] == :error
    bulb = 'green' if inc[:outcome] == :passed
    "<img src='/images/traffic-light-#{bulb}.png'" +
      " border='0'" +
      " width='23'" +
      " height='69'/>"
  end
 
  def tool_tip(inc_number)
    "Open a diff page (#{inc_number})"
  end
    
end
