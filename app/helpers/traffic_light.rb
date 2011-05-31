 
def traffic_light(dojo_name, avatar_name, inc)
  link_to make_light(inc, ''), 
    { :controller => :kata, 
      :action => :review,
      :dojo_name => dojo_name,
      :avatar => avatar_name,
      :tag => inc[:number] 
    }, 
    { :title => inc[:number], 
      :target => '_blank' 
    } 
end

def unlinked_traffic_light(inc)
  make_light(inc, 'unlinked ')
end

def make_light(inc, extra)
  outcome = inc[:outcome].to_s

  red_state   = on_off(outcome, 'failed')
  amber_state = on_off(outcome, 'error')
  green_state = on_off(outcome, 'passed')

  [ "<div class='#{extra}traffic_light'>",
    bulb(red_state),
    bulb(amber_state),
    bulb(green_state),
    "</div>"
  ].join('')  
end

def on_off(outcome, is)
  return outcome == is ? is : 'off'
end

def bulb(state)
  "<span class='#{state} bulb'></span>"  
end
 

