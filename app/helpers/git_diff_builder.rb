
# Work In Progress...

class GitDiffBuilder

  def initialize
  end
  
  def build(diff, lines)    
    result = []
    line_number = 1    
    from = 0    
    diff[:chunks].each do |chunk|
      to = chunk[:range][:now][:start_line] + chunk[:before_lines].length - 1
      line_number = fill(result, :same, lines, from, to, line_number)
      chunk[:sections].each do |section|
        line_number = build_section(result, section, line_number)
      end
      from = line_number - 1      
    end    
    last_lines = lines[line_number-1..lines.length]   
    fill_all(result, :same, last_lines, line_number)    
    result
  end
  
private

  def build_section(result, section, line_number)
    line_number = fill_all(result, :deleted, section[:deleted_lines], line_number)
    line_number = fill_all(result, :added, section[:added_lines], line_number)
    line_number = fill_all(result, :same, section[:after_lines], line_number)
  end

  def fill_all(result, type, lines, line_number)
    lines ||= []
    fill(result, type, lines, 0, lines.length, line_number)
  end
  
  def fill(into, type, lines, from, to, number)
    (from...to).each do |n|
      line = {
        :type => type,
        :line => lines[n]        
      }
      if type != :deleted
        line[:number] = number
        number += 1
      end        
      into << line
    end
    number
  end

end

