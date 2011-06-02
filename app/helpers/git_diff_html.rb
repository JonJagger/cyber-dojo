
def git_diff_html(diff)
  max_digits = diff.length.to_s.length
  lines = diff.map {|n| diff_htmlify(n, max_digits) }.join("\n")
end

def diff_htmlify(n, max_digits)
    "<#{n[:type]}>" +
       '<ln>' + spaced_line_number(n[:number], max_digits) + '</ln>' +
       n[:line] + 
    "</#{n[:type]}>"
end

