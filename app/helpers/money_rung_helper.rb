
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
       "<td class='money_rung #{outcome} amount'>&nbsp</td>",
       "<td></td>",
     '</tr>'   
     ].join("\n")
  end

end

