require 'plural_helper'

module TrafficLightHelper

  include PluralHelper

  def duration_in_minutes(started, finished)
    (finished - started).to_i / 60
  end
  
  def traffic_light(dojo, avatar_name, inc)
    dojo_name = dojo.name
    minutes = duration_in_minutes(dojo.created, Time.mktime(*inc[:time]))
    a_href = link_to make_light(inc), 
    {   :controller => :diff, 
        :action => :show,
        :dojo_name => dojo_name,
        :avatar => avatar_name,
        :tag => inc[:number] 
    }, 
    { :title => tool_tip(avatar_name, inc[:number], minutes),
      :target => '_blank' 
    }
    traffic_light_div('', a_href)
  end

  def tool_tip(avatar_name, inc_number, minutes)
     "View #{avatar_name.humanize} diff #{inc_number} : #{plural(minutes, 'minute')}"
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
