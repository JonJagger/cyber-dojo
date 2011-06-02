
def git_diff_html(diff)
  html = ''
  max_digits = diff.length.to_s.length
  diff.each do |n|
    html += '<ln>' + spaced_line_number(n[:number], max_digits) + '</ln>'
    html += "<#{n[:type]}>" + n[:line] + "</#{n[:type]}>"
  end
  html
end

