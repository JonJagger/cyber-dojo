require 'duration_helper'
require 'plural_helper'

module TrafficLightHelper

  include DurationHelper
  include PluralHelper

  def traffic_light(dojo, avatar_name, inc, in_new_window)
    minutes = duration_in_minutes(dojo.created, Time.mktime(*inc[:time]))
    new_window = in_new_window ? { :target => '_blank' } : {}
    a_href = link_to make_light(inc), 
    {   :controller => :diff, 
        :action => :show,
        :dojo_name => dojo.name,
        :avatar => avatar_name,
        :tag => inc[:number] 
    }, 
    { :title => tool_tip(avatar_name, inc[:number], minutes),
    }.merge(new_window)
    
    traffic_light_div('', a_href)
  end

  def tool_tip(avatar_name, inc_number, minutes)
    #TODO: use minutes as year/month/day/hour/min?
     "Open a diff page (#{inc_number})"
  end
  
  def unlinked_traffic_light(inc)
    traffic_light_div('unlinked ', make_light(inc))
  end
  
  def traffic_light_div(extra, html)
    "<div class='#{extra}traffic_light'>" + html + "</div>"
  end
  
  def make_light(inc)
    outcome = inc[:outcome]  
    [ bulb(on_off(outcome, :failed)), # red
      bulb(on_off(outcome, :error)),  # amber
      bulb(on_off(outcome, :passed)), # green
    ].join('')
  end
  
  def on_off(outcome, is)
    return outcome == is ? is : :off
  end
  
  def bulb(state)
    # This creates an empty span which HTML Validator Tidy warns about
    "<span class='#{state.to_s} bulb'></span>"  
  end
 
end
