
module LadderHelper
  
  def rungs(dojo, ladder)
    
    html = ''
    
    if dojo.expired
      html += small_title('Dojo now closed')
    else
      html += small_title(started(dojo.age))
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
    
  def started(age)
    html = ''
    prefix = ' '    
    if age[:days] > 0
      html += prefix + pluralize(age[:days], 'day')
      prefix = ', '
    end
    html += prefix + "%02d:%02d" % [ age[:mins], age[:secs] ]     
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

    "<td class='mid_tone traffic_light'>" +   
        "<div class='#{red}  increment'></div>" +
        "<div class='#{yellow} increment'></div>" +
        "<div class='#{green} increment'></div>" +  
    '</td>'
  end
  
  def one_rung(rung)
    size = 50
    [  '<td>',
         "<img src='/images/avatars/#{rung[:avatar]}.jpg'",
              "width='#{size}'",
              "height='#{size}'",
              "title='#{rung[:avatar]}' />",
       '</td>',
       traffic_light(rung),       
       '<td>',
         "<img src='/images/avatars/#{rung[:avatar]}.jpg'",
              "width='#{size}'",
              "height='#{size}'",
              "title='#{rung[:avatar]}' />",
       '</td>'  
     ].join("\n")
  end

end

