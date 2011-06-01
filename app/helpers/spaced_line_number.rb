
def spaced_line_number(n, max_digits)
  digit_count = n.to_s.length
  ' ' * (max_digits - digit_count) + n.to_s 
end

