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
    @lines = lines.split("\n")
    @n = 0
  end

  def parse
    prefix_lines = parse_lines(/#{PREFIX_RE}/)
    was_filename = parse_filename(/#{WAS_FILENAME_RE}/)
    now_filename = parse_filename(/#{NOW_FILENAME_RE}/) 

    chunks = []
    while range = /#{RANGE_RE}/.match(@lines[@n])
      was = { 
        :start_line => range[1].to_i, 
        :size => range[2].to_i 
      }
      now = {
        :start_line => range[3].to_i, 
        :size => range[4].to_i 
      }
      range = { :was => was, :now => now }
      @n += 1

      before_lines = parse_lines(/#{COMMON_LINE_RE}/)

      sections = parse_sections
      
      chunk = {
        :range => range,
        #:was => was,
        #:now => now,
        :before_lines => before_lines,
        :sections => sections
      }
      chunks << chunk
    end 

    {
      :prefix_lines => prefix_lines,
      :was_filename => was_filename,
      :now_filename => now_filename,
      :chunks => chunks
    }
    
  end 

private

  def parse_sections
    sections = []
    while @n != @lines.length && !/#{RANGE_RE}/.match(@lines[@n]) do
             
      deleted_lines = parse_lines(/#{DELETED_LINE_RE}/)
      parse_newline_at_eof
      
      added_lines = parse_lines(/#{ADDED_LINE_RE}/)
      parse_newline_at_eof
      
      after_lines = parse_lines(/#{COMMON_LINE_RE}/)
      
      sections << {        
        :deleted_lines => deleted_lines,        
        :added_lines => added_lines,
        :after_lines => after_lines
      }
    end
    sections
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

  def parse_newline_at_eof
    if /#{NEWLINE_AT_EOF_RE}/.match(@lines[@n])
      @n += 1
    end
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
          :range => 
          {
            :was => { :start_line => 4, :size => 7 },
            :now => { :start_line => 5, :size => 8 },
          },
          :before_lines => 
          [ 
            "  (0..n+1).collect {|i| from + i * seconds_per_gap }",
            "end",
            ""
          ],
          :sections =>
          [
            { :deleted_lines =>
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
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).parse

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
          :range =>
          {
            :was => { :start_line => 73, :size => 7 },
            :now => { :start_line => 73, :size => 7 },
          },
          :before_lines => [],
          :sections => []
        }
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).parse
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
          :range =>
          {
            :was => { :start_line => 9, :size => 4 },
            :now => { :start_line => 9, :size => 3 },
          },
          :before_lines => [],
          :sections =>
          [ 
            {          
              :deleted_lines => [ "p Timw.now" ],
              :added_lines   => [ "p Time.now" ],
              :after_lines => []
            }
          ]
        }
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).parse
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
              :range =>
              {
                :was => { :start_line => 9, :size => 4 },
                :now => { :start_line => 9, :size => 3 },
              },
              :before_lines => [],
              :sections =>
              [
                { :deleted_lines => [ "p Timw.now" ],
                  :added_lines   => [ "p Time.now" ],
                  :after_lines => []
                }
              ]
            },
            {
              :range =>
              {
                :was => { :start_line => 19, :size => 4 },
                :now => { :start_line => 19, :size => 3 },
              },
              :before_lines => [],
              :sections =>
              [
                {
                  :deleted_lines => [ "q Timw.now" ],
                  :added_lines   => [ "q Time.now" ],
                  :after_lines => []
                }
              ]      
            }
          ]    
    }
    assert_equal expected, GitDiffParser.new(lines).parse

  end

  #-----------------------------------------------------
  
  def test_when_diffs_are_one_line_apart
  
lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 5ed4618..c47ec44 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -5,9 +5,9 @@
 5
 6
 7
-8
+8a
 9
-10
+10a
 11
 12
 13
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 5ed4618..c47ec44 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              { 
                :was => { :start_line => 5, :size => 9 },
                :now => { :start_line => 5, :size => 9 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines => [ "9" ]
                },
                {
                  :deleted_lines => [ "10" ],
                  :added_lines   => [ "10a" ],
                  :after_lines => [ "11", "12", "13" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse

  end

  #-----------------------------------------------------
  
  def test_when_diffs_are_2_lines_apart
lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 5ed4618..aad3f67 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -5,10 +5,10 @@
 5
 6
 7
-8
+8a
 9
 10
-11
+11a
 12
 13
 14
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 5ed4618..aad3f67 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 10 },
                :now => { :start_line => 5, :size => 10 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines => [ "9", "10" ]
                },
                {
                  :deleted_lines => [ "11" ],
                  :added_lines   => [ "11a" ],
                  :after_lines => [ "12", "13", "14" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse
    
  end

  #-----------------------------------------------------

  def test_when_diffs_are_6_lines_apart
    # when there is 1..6 unchanged lines between 2 lines they are merged into one chunk 
lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 5ed4618..33d0e05 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -5,14 +5,14 @@
 5
 6
 7
-8
+8a
 9
 10
 11
 12
 13
 14
-15
+15a
 16
 17
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 5ed4618..33d0e05 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 14 },
                :now => { :start_line => 5, :size => 14 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines => [ "9", "10", "11", "12", "13", "14" ]
                },
                {
                  :deleted_lines => [ "15" ],
                  :added_lines   => [ "15a" ],
                  :after_lines => [ "16", "17" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse
  end    
  
  #-----------------------------------------------------
  
  def test_when_diffs_are_seven_lines_apart
    # viz 7 unchanged lines between two changes lines
    # this creates two chunks.
lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 5ed4618..e78c888 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -5,7 +5,7 @@
 5
 6
 7
-8
+8a
 9
 10
 11
@@ -13,7 +13,7 @@
 13
 14
 15
-16
+16a
 17
 18
 19
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 5ed4618..e78c888 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 7 },
                :now => { :start_line => 5, :size => 7 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines => [ "9", "10", "11" ]
                }
              ]
            },
            {
              :range =>
              {
                :was => { :start_line => 13, :size => 7 },
                :now => { :start_line => 13, :size => 7 },
              },
              :before_lines => [ "13", "14", "15" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "16" ],
                  :added_lines   => [ "16a" ],
                  :after_lines => [ "17", "18", "19" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse
    
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

