 
def traffic_light(dojo_name, avatar_name, rung)
  # I'd like the horizontal spacing between dashboard traffic lights to be 
  # proportional to the time difference between them. I first tried this
  # by calculating the number of seconds between traffic lights. However
  # this is not satifactory because each traffic light itself takes up a 
  # certain width. Hence an avatar hitting the run-tests button a lot
  # will naturally takes up quite a lot of horizontal space. The best
  # solution I can think of is to split each traffic light tr into the 
  # same number of td's and make each td represent a fixed period of time,
  # say 15 seconds. 
  # When doing this it will be important not to make the period shown end 
  # with the current time, but end with the time of the most recent increment.
  # Otherwise, as time goes on I will create more and more empty td's to
  # the right of the tr. This could cause scroll-bars to appear.
  # I don't want scroll-bars since the traffic-lights on the dashboard 
  # automatically refresh every few seconds and this would interfere with
  # the scrolling. The best way to combat this is to limit the number of
  # td's on a tr, and if there are too many, to simply chop off early ones.
  # This is what I do on the main play page where I limit the number of
  # traffic-lights to only a few (eg 7) and I don't space them out.
  
  outcome = rung[:outcome].to_s

  red   = on_off(outcome, 'failed')
  amber = on_off(outcome, 'error')
  green = on_off(outcome, 'passed')

  [ '<td class="traffic_light">',
    aref(dojo_name, avatar_name, rung, red),
    aref(dojo_name, avatar_name, rung, amber),
    aref(dojo_name, avatar_name, rung, green),
    '</td>',
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
 

