
module MoneyRungHelper
	
	def rungs(ladder, name)
		html = ''
		symbol = (name + '_rungs').to_sym
    ladder[symbol].each_with_index do |rung,index|
    	html = html + money_rung(rung, index, name) 
    end
    html
	end
		
  def money_rung(rung, index, outcome)
 	
  	if outcome == "passed" and index == 0
      html = button_to_remote("&lt;Bank", {:update => "money_ladder", 
                                           :url => { :action => "bank",
                                          	         :dojo => @dojo.name }},
                                          {:id => "bank_button"})
    else
			html = ""
		end

  	size = 45
  	
    ['<tr>',
       '<td>',
         "<img src='/images/avatars/#{rung[:avatar]}.jpg'",
              "width='#{size}'",
              "height='#{size}'",
              "title='#{rung[:avatar]}' />",
       '</td>',
       '<td>',
       "<img src='/images/avatars/#{rung[:avatar]}.jpg'",
              "width='#{size}'",
              "height='#{size}'",
              "title='#{rung[:avatar]}' />",
       '</td>',
       "<td class='money_rung #{outcome} amount'>#{commatize(rung[:amount])}</td>",
       "<td>#{html}</td>",
     '</tr>'   
     ].join("\n")
  end

end

