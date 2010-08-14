
module MoneyRungHelper
	
  def money_rung(rung, size, outcome, amount)
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
       "<td class='money_rung #{outcome} amount'>#{amount}</td>",
     '</tr>'   
     ].join("\n")
  end

end


