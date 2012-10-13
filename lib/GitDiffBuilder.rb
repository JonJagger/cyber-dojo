
module GitDiff

  # Combines diff and lines to build a data structure that
  # containes a complete view of a file;
  #    the lines that were deleted
  #    the lines that were added
  #    the lines that have stayed the same.
  #
  # diff: created from GitDiffParser. The diff between
  #       sucessive tags (run-tests) of a file.
  #
  # lines: an array containing the current content of the 
  #        diffed file.
  
  class GitDiffBuilder
  
    def initialize
      @line_number = 1
    end

    def build(diff, lines)    
      result = [ ]
      from = 0
      index = 0
      diff[:chunks].each do |chunk|
        to = chunk[:range][:now][:start_line] + chunk[:before_lines].length - 1
        line_number = fill(result, :same, lines, from, to)
        chunk[:sections].each do |section|
          result << { :type => :section, :index => index }
          index += 1
          build_section(result, section)
        end
        from = @line_number - 1      
      end    
      last_lines = lines[@line_number-1..lines.length]   
      fill_all(result, :same, last_lines)
      result
    end
    
  private
  
    def build_section(result, section)
      fill_all(result, :deleted, section[:deleted_lines])
      fill_all(result, :added, section[:added_lines])
      fill_all(result, :same, section[:after_lines])
    end
  
    def fill_all(result, type, lines)
      lines ||= [ ] 
      fill(result, type, lines, 0, lines.length)
    end
    
    def fill(into, type, lines, from, to)
      (from...to).each do |n|
        line = {
          :type => type,
          :line => lines[n]        
        }
        if type != :deleted
          line[:number] = @line_number
          @line_number += 1
        end        
        into << line
      end
    end
  
  end

end
