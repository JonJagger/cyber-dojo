
class GitDiffParser 

  def initialize(diff_text)
    @lines = line_split(diff_text) 
    @n = 0
  end

  def lines
    @lines
  end
  
  def n
    @n
  end
  
  def parse_all
    all = {}
    while /^diff/.match(@lines[@n]) do
      one = parse_one
      if one[:now_filename] != '/dev/null'
        name = one[:now_filename]
      else
        name = one[:was_filename]
      end
      all[name] = one      
    end
    all
  end

  def parse_one
    {
      :prefix_lines => parse_prefix_lines,
      :was_filename => parse_was_filename,
      :now_filename => parse_now_filename,
      :chunks => parse_chunk_all
    }
  end

  def parse_chunk_all
    chunks = []     
    while chunk = parse_chunk_one
      chunks << chunk
    end
    chunks
  end

  def parse_chunk_one
    if range = parse_range
      {
        :range => range,
        :before_lines => parse_common_lines,
        :sections => parse_sections
      }      
    end
  end

  RANGE_RE = /^@@ -(\d+),?(\d+)? \+(\d+),?(\d+)? @@.*/

  def parse_range
    if range = RANGE_RE.match(@lines[@n])
      @n += 1
      was = { :start_line => range[1].to_i, 
              :size => size_or_default(range[2]) 
            }
      now = { :start_line => range[3].to_i, 
              :size => size_or_default(range[4]) 
            }
      { :was => was, :now => now } 
    else
      nil
    end
  end

  def size_or_default(size)
    #http://www.artima.com/weblogs/viewpost.jsp?thread=164293
    #Is a blog entry by Guido van Rossum.
    #He says that in L,S the ,S can be omitted if the chunk size
    #S is 1. So -3 is the same as -3,1
    size != nil ? size.to_i : 1 
  end

  DELETED_LINE_OR_ADDED_LINE_OR_COMMON_LINE_RE = /^[\+\- ]/ 

  def parse_sections
    sections = []
    while DELETED_LINE_OR_ADDED_LINE_OR_COMMON_LINE_RE.match(@lines[@n]) do
             
      deleted_lines = parse_deleted_lines
      parse_newline_at_eof
      
      added_lines = parse_added_lines
      parse_newline_at_eof
      
      after_lines = parse_common_lines
      parse_newline_at_eof
      
      sections << {        
        :deleted_lines => deleted_lines,        
        :added_lines => added_lines,
        :after_lines => after_lines
      }
    end
    sections
  end

  DELETED_LINE_RE = /^\-(.*)/

  def parse_deleted_lines
    parse_lines(DELETED_LINE_RE)
  end

  ADDED_LINE_RE   = /^\+(.*)/

  def parse_added_lines
    parse_lines(ADDED_LINE_RE)
  end

  COMMON_LINE_RE = %r|^ (.*)|

  def parse_common_lines
    parse_lines(COMMON_LINE_RE)
  end

  PREFIX_RE = %r|^([^-+].*)|

  def parse_prefix_lines
    parse_lines(PREFIX_RE)
  end

  WAS_FILENAME_RE = %r|^\-\-\- (.*)|

  def parse_was_filename
    parse_filename(WAS_FILENAME_RE)
  end

  NOW_FILENAME_RE = %r|^\+\+\+ (.*)|

  def parse_now_filename
    parse_filename(NOW_FILENAME_RE)
  end
  
  def parse_filename(re)
    if md = re.match(@lines[@n])
      @n += 1
      md[1]
    end    
  end
  
  def parse_lines(re)
    lines = []
    while md = re.match(@lines[@n]) do
      lines << md[1]
      @n += 1
    end
    lines
  end

  NEWLINE_AT_EOF_RE = /^\\ No newline at end of file/
  
  def parse_newline_at_eof
    if NEWLINE_AT_EOF_RE.match(@lines[@n])
      @n += 1
    end
  end

end


#--------------------------------------------------------------
# Git diff format notes
#
#LINE: --- a/sandbox/gapper.rb
#
#  The original file is preceded by --- 
#  If this is a new file this is --- /dev/null
#
#LINE: +++ b/sandbox/gapper.rb
#
#  The new file is preceded by +++
#  If this is a deleted file this is +++ /dev/null
#
#LINE: @@ -4,7 +4,8 @@ def time_gaps(from, to, seconds_per_gap)
#
#  Following this is a change chunk containing the line differences.
#  A chunk begins with range information. The range information 
#  is surrounded by double-at signs. 
#    So in this example its @@ -4,7 +4,8 @@
#  The chunk range information contains two chunk ranges. 
#  Each chunk range is of the format L,S where 
#  L is the starting line number and 
#  S is the number of lines the change chunk applies to for 
#  each respective file.
#  The ,S is optional and if missing indicates a chunk size of 1.
#  So -3 is the same as -3,1 and -1 is the same as -1,1
#
#  The range for the chunk of the original file is preceded by a 
#  minus symbol. 
#    So in this example its -4,7
#  If this is a new file (--- /dev/null) this is -0,0
#
#  The range for the chunk of the new file is preceded by a 
#  plus symbol. 
#    So in this example its +4,8
#  If this is a deleted file (+++ /dev/null) this is -0,0
#
#LINE:   (0..n+1).collect {|i| from + i * seconds_per_gap }
#LINE: end
#LINE: 
#
#  Following this, optionally, are the unchanged, contextual lines,
#  each preceded by a space character.
#  These are lines that are common to both the old file and the new file.
#  So here there are three lines, (the third line is a newline)
#  So the -4,7 tells us that these three common lines are lines
#  4,5,6 in the original file.
#
#LINE:-def full_gapper(all_incs, gaps)
#
#  Following this, optionally, are the deleted lines, each preceded by a 
#  minus sign. This is the first deleted line so it was line 7 (one after 6)
#  If there were subsequent deleted lines they would having incrementing line
#  numbers, 8,9 etc.
#
#LINE:\ No newline at end of file
#
#  Following this, optionally, is a single line starting with a \ character
#  as above.
# 
#LINE:+def full_gapper(all_incs, created, seconds_per_gap)
#LINE:+  gaps = time_gaps(created, latest(all_incs), seconds_per_gap)
#
#  Following this, optionally, are the added lines, each preceeded by a
#  + sign. So the +4,8 and the 3 common lines tells us that the first +
#  line is line 7 in the new file, and the second + line is line 8 in
#  the new file.
#
#LINE:\ No newline at end of file
#
#  Following this, optionally, is a single line starting with a \ character
#  as above.
#--------------------------------------------------------------

