
module LadderHelper
	
	def rungs(ladder)
		html = '<table>'
		ladder.each do |rung|
			html += one_rung(rung) 
		end
		html += '</table>'
	end
		
	def on_off(outcome, is)
		return outcome == is ? 'on' : 'off'
	end
	
	def traffic_light(rung)
		outcome = rung[:outcome].to_s
		
		red = on_off(outcome, 'failed')
		yellow = on_off(outcome, 'error')
		green = on_off(outcome, 'passed')
		
		'<div>' + 
		"<div class='#{outcome} #{red}  increment'></div>" +
		"<div class='#{outcome} #{yellow} increment'></div>" +
		"<div class='#{outcome} #{green} increment'></div>" +	
		'</div>'
	end
	
  def one_rung(rung)
  	size = 45
  	
    ['<tr>',
       '<td>',
         "<img src='/images/avatars/#{rung[:avatar]}.jpg'",
              "width='#{size}'",
              "height='#{size}'",
              "title='#{rung[:avatar]}' />",
       '</td>',
       "<td class='mid_tone traffic_light'>#{traffic_light(rung)}</td>",       
       '<td>',
         "<img src='/images/avatars/#{rung[:avatar]}.jpg'",
              "width='#{size}'",
              "height='#{size}'",
              "title='#{rung[:avatar]}' />",
       '</td>',
     '</tr>'   
     ].join("\n")
  end

end

