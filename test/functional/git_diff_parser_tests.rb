require 'test/unit'

# Work In Progress...

class GitDiffParser

  PREFIX_RE         = '(^[^-+].*)'
  WAS_FILENAME_RE   = '^--- a/(.*)'
  NOW_FILENAME_RE   = '^\+\+\+ b/(.*)'

  RANGE_RE          = '^@@ -(\d+),(\d+) \+(\d+),(\d+) @@.*'
  COMMON_LINE_RE    = '^[^-+@](.*)'
  DELETED_LINE_RE   = '^\-(.*)'
  NEWLINE_AT_EOF_RE = '^\\ No newline at end of file'
  ADDED_LINE_RE     = '^\+(.*)'

  def initialize(lines)
    lines = lines.split("\n")

    n = 0

    @prefix_lines = []
    while md = /#{PREFIX_RE}/.match(lines[n]) do
      @prefix_lines << md[1]
      n += 1
    end

    if md = /#{WAS_FILENAME_RE}/.match(lines[n])
      @was_filename = md[1]
      n += 1
    end

    if md = /#{NOW_FILENAME_RE}/.match(lines[n])
      @now_filename = md[1]
      n += 1
    end

    @chunks = []
    while range = /#{RANGE_RE}/.match(lines[n])
      was = { 
        :start_line => range[1].to_i, 
        :size => range[2].to_i 
      }
      now = {
        :start_line => range[3].to_i, 
        :size => range[4].to_i 
      }
      n += 1

      before_lines = []
      while md = /#{COMMON_LINE_RE}/.match(lines[n]) do
        before_lines << md[1]
        n += 1
      end

      deleted_lines = []
      while md = /#{DELETED_LINE_RE}/.match(lines[n]) do
        deleted_lines << md[1]
        n += 1    
      end  
      if /#{NEWLINE_AT_EOF_RE}/.match(lines[n])
        n += 1
      end

      added_lines = []
      while md = /#{ADDED_LINE_RE}/.match(lines[n]) do
        added_lines << md[1]
        n += 1
      end
      if /#{NEWLINE_AT_EOF_RE}/.match(lines[n])
        n += 1
      end
  
      after_lines = []
      while md = /#{COMMON_LINE_RE}/.match(lines[n]) do
        after_lines << md[1]
        n += 1
      end    
      
      chunk = {
        :was => was,
        :now => now,
        :before_lines => before_lines,
        :deleted_lines => deleted_lines,
        :added_lines => added_lines,
        :after_lines => after_lines
      }
      @chunks << chunk

    end # while

  end

  def prefix_lines; @prefix_lines; end
  def was_filename; @was_filename; end
  def now_filename; @now_filename; end
  def chunks; @chunks; end

  def obj
    {
      :prefix_lines => prefix_lines,
      :was_filename => was_filename,
      :now_filename => now_filename,
      :chunks => chunks
    }
  end

end

#--------------------------------------------

class TestGitDiffParser < Test::Unit::TestCase

  def test_standard_diff

lines = <<HERE
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
      :was_filename => 'sandbox/gapper.rb',
      :now_filename => 'sandbox/gapper.rb',
      :chunks => 
      [
        {
          :was => { :start_line => 4, :size => 7 },
          :now => { :start_line => 5, :size => 8 },
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
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).obj

  end

#-----------------------------------------------------

  def test_find_copies_harder_finds_a_rename

lines = <<HERE
diff --git a/sandbox/oldname b/sandbox/newname
similarity index 99%
rename from sandbox/oldname
rename to sandbox/newname
index afcb4df..c0f407c 100644
--- a/sandbox/oldname
+++ b/sandbox/newname
@@ -73,7 +73,7 @@ LINE: +++ /dev/null
HERE

    expected = 
    {
      :prefix_lines =>  
      [
        "diff --git a/sandbox/oldname b/sandbox/newname",
        "similarity index 99%",
        "rename from sandbox/oldname",
        "rename to sandbox/newname",
        "index afcb4df..c0f407c 100644"
      ],
      :was_filename => 'sandbox/oldname',
      :now_filename => 'sandbox/newname',
      :chunks =>
      [
        {
          :was => { :start_line => 73, :size => 7 },
          :now => { :start_line => 73, :size => 7 },
          :before_lines => [],
          :deleted_lines => [],
          :added_lines => [],
          :after_lines => []
        }
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).obj  
  end

#-----------------------------------------------------

  def test_when_newline_at_end_of_file_is_present

lines = <<HERE
diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb
index 4d3ca1b..61e88f0 100644
--- a/sandbox/test_gapper.rb
+++ b/sandbox/test_gapper.rb
@@ -9,4 +9,3 @@ class TestGapper < Test::Unit::TestCase
-p Timw.now
\ No newline at end of file
+p Time.now
\ No newline at end of file
HERE

    expected =
    {
      :prefix_lines =>  
      [
        "diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb",
        "index 4d3ca1b..61e88f0 100644"
      ],
      :was_filename => 'sandbox/test_gapper.rb',
      :now_filename => 'sandbox/test_gapper.rb',
      :chunks =>
      [
        {
          :was => { :start_line => 9, :size => 4 },
          :now => { :start_line => 9, :size => 3 },
          :before_lines => [],
          :deleted_lines => [ "p Timw.now" ],
          :added_lines   => [ "p Time.now" ],
          :after_lines => []      
        }
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).obj
  end  

#-----------------------------------------------------

  def test_when_two_chunks_are_present

lines = <<HERE
diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb
index 4d3ca1b..61e88f0 100644
--- a/sandbox/test_gapper.rb
+++ b/sandbox/test_gapper.rb
@@ -9,4 +9,3 @@ class TestGapper < Test::Unit::TestCase
-p Timw.now
+p Time.now
\ No newline at end of file
@@ -19,4 +19,3 @@ class TestGapper < Test::Unit::TestCase
-q Timw.now
+q Time.now
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb",
            "index 4d3ca1b..61e88f0 100644"
          ],
        :was_filename => 'sandbox/test_gapper.rb',
        :now_filename => 'sandbox/test_gapper.rb',
        :chunks =>
          [
            {
              :was =>
              { 
                :start_line => 9, 
                :size => 4 
              },
              :now =>
                { 
                  :start_line => 9, 
                  :size => 3 
                },
              :before_lines => [],
              :deleted_lines => [ "p Timw.now" ],
              :added_lines   => [ "p Time.now" ],
              :after_lines => []      
            },
            {
              :was =>
              { 
                :start_line => 19, 
                :size => 4 
              },
              :now =>
                { 
                  :start_line => 19, 
                  :size => 3 
                },
              :before_lines => [],
              :deleted_lines => [ "q Timw.now" ],
              :added_lines   => [ "q Time.now" ],
              :after_lines => []      
            }
          ]    
    }
    assert_equal expected, GitDiffParser.new(lines).obj

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

