
module LadderHelper
  
  def rungs(dojo, avatar_name) 
    html = title(age_or_closed(dojo))
    
    if @dojo.avatars.length == 1
      return html
    end
      
    ladder = []
    dojo.avatars.each do |avatar|
      rung = { :avatar => avatar.name }
      incs = avatar.increments

      if incs.length > 0 
        rung[:outcome] = incs.last[:outcome]
      else
        rung[:outcome] = :blank 
      end
      rung[:number] = incs.length
      ladder << rung
    end   
    
    html += '<table cellspacing="4">'
    chunks = chunk_array(ladder, 8)
    chunks.each do |chunk|
      html += '<tr>'
      chunk.each do |rung|
        html += one_rung(dojo.name, rung[:avatar], rung)
      end
      html += '</tr>'
    end
    html += '</table>'
  end
    
  def age_or_closed(dojo)
    if dojo.closed
      'This CyberDojo has ended'
    else
      age = dojo.age
      "%02dh:%02dm:%02ds" % [ age[:hours], age[:mins], age[:secs] ]
    end
  end
  
  def title(html)
    '<span class="small_title">' + html + '</span>'
  end
  
  def on_off(outcome, is)
    return outcome == is ? is : 'off'
  end
  
  def traffic_light(dojo_name, avatar_name, rung)
    outcome = rung[:outcome].to_s
    
    red   = on_off(outcome, 'failed')
    amber = on_off(outcome, 'error')
    green = on_off(outcome, 'passed')

    [ 
      '<td class="traffic_light">',
      aref(dojo_name, avatar_name, rung, red),
      aref(dojo_name, avatar_name, rung, amber),
      aref(dojo_name, avatar_name, rung, green),
      '</td>',
    ].join('')
  end
  
  def aref(dojo_name, avatar_name, rung, colour)
    link_to "<span class='#{colour} increment'></span>", 
      { :controller => :kata, 
        :action => "view?dojo_name=#{dojo_name}&avatar=#{avatar_name}&tag=#{rung[:number]}" 
      }, 
      { :title => "#{rung[:number]}", 
        :target => "_blank" 
      } 
  end
  
  def one_rung(dojo_name, avatar_name, rung)
    [  
      td(avatar_image(avatar_name, 45)),
      traffic_light(dojo_name, avatar_name, rung),       
    ].join('')
  end

  def td(html)
    '<td>' + html + '</td>' 
  end
  
end

