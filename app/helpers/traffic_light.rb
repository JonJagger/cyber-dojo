 
def traffic_light(dojo_name, avatar_name, rung)
  outcome = rung[:outcome].to_s

  red   = on_off(outcome, 'failed')
  amber = on_off(outcome, 'error')
  green = on_off(outcome, 'passed')

  [ aref(dojo_name, avatar_name, rung, red),
    aref(dojo_name, avatar_name, rung, amber),
    aref(dojo_name, avatar_name, rung, green),
  ].join('')
end

def on_off(outcome, is)
  return outcome == is ? is : 'off'
end

def aref(dojo_name, avatar_name, rung, colour)
  link_to "<span class='#{colour} increment'></span>", 
    { :controller => :kata, 
      :action => "review?dojo_name=#{dojo_name}&avatar=#{avatar_name}&tag=#{rung[:number]}" 
    }, 
    { :title => "#{rung[:number]}", 
      :target => "_blank" 
    } 
end
 

