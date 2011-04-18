
module LadderHelper
  
  def rungs(dojo) 
    html = age_or_closed(dojo)
    
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
      ladder << rung
    end   
    
    html += '<table cellspacing="4">'
    chunks = chunk_array(ladder, 12)
    chunks.each do |chunk|
      html += '<tr>'
      chunk.each do |rung|
        html += one_rung(rung)
      end
      html += '</tr>'
    end
    html += '</table>'
  end
    
  def age_or_closed(dojo)
    if dojo.closed
      small_title('This CyberDojo has ended')
    else
      age = dojo.age
      small_title("%02dh:%02dm:%02ds" % [ age[:hours], age[:mins], age[:secs] ])
    end
  end
  
  def small_title(html)
    '<span class="small_title">' + html + '</span>'
  end
  
  def on_off(outcome, is)
    return outcome == is ? is : 'off'
  end
  
  def traffic_light(rung)
    outcome = rung[:outcome].to_s
    
    red = on_off(outcome, 'failed')
    yellow = on_off(outcome, 'error')
    green = on_off(outcome, 'passed')

    [ "<td class='mid_tone traffic_light'>",   
        "<div class='#{red}  increment'></div>",
        "<div class='#{yellow} increment'></div>",
        "<div class='#{green} increment'></div>",  
      '</td>'
    ].join('')
  end
  
  def one_rung(rung)
    [  td(avatar_image(rung[:avatar], 50)),
       traffic_light(rung),       
    ].join('')
  end

  def td(html)
    '<td>' + html + '</td>' 
  end
  
end

