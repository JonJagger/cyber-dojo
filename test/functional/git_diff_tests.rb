require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/git_diff_tests.rb

require 'test/unit'

class GitDiff

  PREFIX_RE       = '(^[^-+].*)'
  WAS_FILENAME_RE = '^--- a/(.*)'
  NOW_FILENAME_RE = '^\+\+\+ b/(.*)'
  RANGE_RE        = '^@@ -(\d+),(\d+) \+(\d+),(\d+) @@.*'
  COMMON_LINE_RE  = '^[^-+](.*)'
  DELETED_LINE_RE = '-(.*)'
  ADDED_LINE_RE   = '\+(.*)'

  def initialize(lines)
    lines = lines.split("\n")

    n = 0

    @prefix_lines = []
    while md = /#{PREFIX_RE}/.match(lines[n]) do
      @prefix_lines << md[1]
      n += 1
    end

    was_filename = /#{WAS_FILENAME_RE}/.match(lines[n])
    n += 1

    now_filename = /#{NOW_FILENAME_RE}/.match(lines[n])
    n += 1

    range = /#{RANGE_RE}/.match(lines[n])
    @was = { 
      :filename => was_filename[1],
      :start_line => range[1].to_i, 
      :size => range[2].to_i 
    }
    @now = {
      :filename => now_filename[1],
      :start_line => range[3].to_i, 
      :size => range[4].to_i 
    }
    n += 1

    @before_lines = []
    while md = /#{COMMON_LINE_RE}/.match(lines[n]) do
      @before_lines << md[1]
      n += 1
    end

    @deleted_lines = []
    while md = /#{DELETED_LINE_RE}/.match(lines[n]) do
      @deleted_lines << md[1]
      n += 1    
    end
    #TODO \ newline optional

    @added_lines = []
    while md = /#{ADDED_LINE_RE}/.match(lines[n]) do
      @added_lines << md[1]
      n += 1
    end
    #TODO \ newline optional

    @after_lines = []
    while md = /#{COMMON_LINE_RE}/.match(lines[n]) do
      @after_lines << md[1]
      n += 1
    end    

  end

  def prefix_lines; @prefix_lines; end
  def now; @now; end
  def was; @was; end
  def before_lines; @before_lines; end
  def deleted_lines; @deleted_lines; end
  def added_lines; @added_lines; end
  def after_lines; @after_lines; end

  def obj
    {
      :prefix_lines => prefix_lines,
      :now => now,
      :was => was,
      :before_lines => before_lines,
      :deleted_lines => deleted_lines,
      :added_lines => added_lines,
      :after_lines => after_lines
    }
  end

end

#--------------------------------------------

class TestGitDiff < Test::Unit::TestCase

  def test_git_diff

p = <<HERE
diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb
index 26bc41b..8a5b0b7 100644
--- a/sandbox/gapper.rb
+++ b/sandbox/gapper.rb
@@ -4,7 +5,8 @@ def time_gaps(from, to, seconds_per_gap)
   (0..n+1).collect {|i| from + i * seconds_per_gap }
 end
 
-def full_gapper(all_incs, gaps)
+def full_gapper(all_incs, created, seconds_per_gap)
+  gaps = time_gaps(created, latest(all_incs), seconds_per_gap)
   full = {}
   all_incs.each do |avatar_name, incs|
     full[avatar_name.to_sym] = gapper(incs, gaps)
HERE

    expected = 
    {
      :prefix_lines =>  
        [
          "diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb",
          "index 26bc41b..8a5b0b7 100644"
        ],
      :was =>
        { 
          :filename => 'sandbox/gapper.rb',
          :start_line => 4, 
          :size => 7 
        },
      :now =>
        { 
          :filename => 'sandbox/gapper.rb',
          :start_line => 5, 
          :size => 8 
        },
      :before_lines => 
        [ 
          "  (0..n+1).collect {|i| from + i * seconds_per_gap }",
          "end",
          ""
        ],
      :deleted_lines =>
        [
          "def full_gapper(all_incs, gaps)"
        ],
      :added_lines =>
        [
          "def full_gapper(all_incs, created, seconds_per_gap)",
          "  gaps = time_gaps(created, latest(all_incs), seconds_per_gap)"
        ],
      :after_lines =>
        [
          "  full = {}",
          "  all_incs.each do |avatar_name, incs|",
          "    full[avatar_name.to_sym] = gapper(incs, gaps)"
        ]
    }
    assert_equal expected, GitDiff.new(p).obj

  end

end


#--------------------------------------------------------------
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

