 
def traffic_light(dojo_name, avatar_name, rung)
  outcome = rung[:outcome].to_s

  red   = on_off(outcome, 'failed')
  amber = on_off(outcome, 'error')
  green = on_off(outcome, 'passed')

  [ bulb(dojo_name, avatar_name, rung, red),
    bulb(dojo_name, avatar_name, rung, amber),
    bulb(dojo_name, avatar_name, rung, green),
  ].join('')
end

def on_off(outcome, is)
  return outcome == is ? is : 'off'
end

def bulb(dojo_name, avatar_name, rung, colour)
  link_to "<span class='#{colour} traffic_light_bulb'></span>", 
    { :controller => :kata, 
      :action => "review?dojo_name=#{dojo_name}&avatar=#{avatar_name}&tag=#{rung[:number]}" 
    }, 
    { :title => "#{rung[:number]}", 
      :target => "_blank" 
    } 
end
 

