
def td_dot(kind)
  "<td><div class='#{kind} dot'></div></td>"
end

def diff_dots(n, kind)
  max_dots = 4
  html = '<table>'
  html += '<tr>'
  
  if kind == 'deleted'
    if n <= max_dots
      (max_dots - n).times { html += td_dot('spacer') }
    else
      html += '<td><more_diff_dots></more_diff_dots></td>'
    end
  end  
  
  [max_dots,n].min.times { html += td_dot(kind) }
  
  if kind == 'added'
    if n <= max_dots
      (max_dots - n).times { html += td_dot('spacer') }
    else
      html += '<td><more_diff_dots></more_diff_dots></td>'
    end
  end
  
  html += '</tr>'
  html += '</table>'
end

