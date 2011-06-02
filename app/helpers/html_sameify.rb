
def html_sameify(samed)
  html = ''
  max_digits = samed.length.to_s.length
  samed.each do |n|
    html += '<ln>' + spaced_line_number(n[:number], max_digits) + '</ln>'
    html += "<#{n[:type]}>" + n[:line] + "</#{n[:type]}>"
  end
  html
end

