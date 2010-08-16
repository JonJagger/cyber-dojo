
module MoneyRungHelper
	
  def money_rung(rung, outcome)
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
     '</tr>'   
     ].join("\n")
  end

end


