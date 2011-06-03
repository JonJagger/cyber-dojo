
def diff_dots(n, kind)
  max = [n,4].min
  html = '<table>'
  html += '<tr>'     
  html += '<td><more_diff_dots></more_diff_dots></td>' if kind == 'deleted' && n > max     
  max.times { html += "<td><div class='#{kind} dot'></div></td>" }
  html += '<td><more_diff_dots></more_diff_dots></td>' if kind == 'added'   && n > max
  html += '</tr>'
  html += '</table>'
end

