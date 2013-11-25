
module TrafficLightHelper

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
    { :title => tool_tip(avatar_name, inc),
    }.merge(new_window)
  end
  
  def untitled_unlinked_traffic_light(inc, width = nil, height = nil)
    width ||= 20
    height ||= 62
    colour = inc[:colour].to_s
    filename = "traffic_light_#{colour}"
    base_traffic_light_image(filename + '.png',colour,width,height)
  end
  
  def traffic_light_image(colour, width, height)
    base_traffic_light_image("traffic_light_#{colour}.png",colour,width,height)
  end
  
  def base_traffic_light_image(filename, colour, width, height)
    ("<img src='/images/#{filename}'" +
      " alt='#{colour} traffic-light'" +
      " width='#{width}'" +
      " height='#{height}'/>").html_safe    
  end
  
  def unlinked_traffic_light(inc, width = nil, height = nil)
    bulb = inc[:colour].to_s
    ("<span title='#{at(inc)}'>" +
     untitled_unlinked_traffic_light(inc, width, height) +
     "</span>").html_safe
  end
 
  def tool_tip(avatar_name, inc)
    n = inc[:number]
    "Show #{avatar_name}'s diff #{n-1} -> #{n} (#{at(inc)})"
  end
    
  def at(inc)
    Time.mktime(*inc[:time]).strftime("%Y %b %-d, %H:%M:%S")    
  end
  
end
