require 'test_helper'

# Work In Progress...

class TestGitDiffParser < ActionController::TestCase 

  def test_parse_diffs_for_two_files

lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 896ddd8..2c8d1b8 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -1,7 +1,7 @@
 1
 2
 3
-4
+4a
 5
 6
 7
diff --git a/sandbox/other b/sandbox/other
index cf0389a..b28bf03 100644
--- a/sandbox/other
+++ b/sandbox/other
@@ -1,6 +1,6 @@
 1
 2
-3
-4
+3a
+4a
 5
 6
\ No newline at end of file
HERE
    
    expected_diff_1 =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 896ddd8..2c8d1b8 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 6 },
                :now => { :start_line => 1, :size => 6 },
              },
              :before_lines => [ "1", "2"],
              :sections =>
              [
                {
                  :deleted_lines => [ "3", "4" ],
                  :added_lines   => [ "4a" ],
                  :after_lines => [ "5", "6" ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
  
    expected_diff_2 =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/other b/sandbox/other",
            "index cf0389a..b28bf03 100644"
          ],
        :was_filename => 'sandbox/other',
        :now_filename => 'sandbox/other',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 6 },
                :now => { :start_line => 1, :size => 6 },
              },
              :before_lines => [ "1", "2"],
              :sections =>
              [
                {
                  :deleted_lines => [ "3", "4" ],
                  :added_lines   => [ "3a", "4a" ],
                  :after_lines => [ "5", "6" ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
    
    expected = 
    {
      'sandbox/lines' => expected_diff_1,
      'sandbox/other' => expected_diff_2
    }
    
    assert_equal expected, GitDiffParser.new(lines).parse_all

  end
  
  #-----------------------------------------------------

  def test_parse_range_was_and_now_size_defaulted
    lines = "@@ -3 +5 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 1 },
      :now => { :start_line => 5, :size => 1 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------
  
  def test_parse_range_was_size_defaulted
    lines = "@@ -3 +5,9 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 1 },
      :now => { :start_line => 5, :size => 9 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------

  def test_parse_range_now_size_defaulted
    lines = "@@ -3,4 +5 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 4 },
      :now => { :start_line => 5, :size => 1 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------
  
  def test_parse_range_nothing_defaulted
    lines = "@@ -3,4 +5,6 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 4 },
      :now => { :start_line => 5, :size => 6 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------
  
  def test_parse_chunk_with_defaulted_line_info
    
lines = <<HERE
diff --git a/sandbox/untitled_5G3 b/sandbox/untitled_5G3
index e69de29..2e65efe 100644
--- a/sandbox/untitled_5G3
+++ b/sandbox/untitled_5G3
@@ -0,0 +1 @@
+a
\\ No newline at end of file
HERE

    #http://www.artima.com/weblogs/viewpost.jsp?thread=164293
    #Is a blog entry by Guido van Rossum.
    #He says that in L,S the ,S can be omitted if the chunk size
    #S is 1. So -3 is the same as -3,1

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/untitled_5G3 b/sandbox/untitled_5G3",
            "index e69de29..2e65efe 100644"
          ],
        :was_filename => 'sandbox/untitled_5G3',
        :now_filename => 'sandbox/untitled_5G3',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 0, :size => 0 },
                :now => { :start_line => 1, :size => 1 },
              },
              :before_lines => [ ],
              :sections =>
              [
                {
                  :deleted_lines => [ ],
                  :added_lines   => [ "a" ],
                  :after_lines => [ ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
    
    assert_equal expected, GitDiffParser.new(lines).parse

  end

  #-----------------------------------------------------
  
  def test_parse_no_newline_at_eof_false
    lines = ' No newline at eof'
    parser = GitDiffParser.new(lines)

    assert 0, parser.n
    parser.parse_newline_at_eof
    assert 0, parser.n        
  end
  
  #-----------------------------------------------------

  def test_parse_no_newline_at_eof_true
    lines = '\\ No newline at eof'
    parser = GitDiffParser.new(lines)

    assert 0, parser.n
    parser.parse_newline_at_eof
    assert 1, parser.n        
  end
  
  #-----------------------------------------------------
  
  def test_two_chunks_with_no_newline_at_end_of_file
    
lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index b1a30d9..7fa9727 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -1,5 +1,5 @@
 1
-2
+2a
 3
 4
 5
@@ -8,6 +8,6 @@
 8
 9
 10
-11
+11a
 12
 13
\\ No newline at end of file
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index b1a30d9..7fa9727 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 5 },
                :now => { :start_line => 1, :size => 5 },
              },
              :before_lines => [ "1" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "2" ],
                  :added_lines   => [ "2a" ],
                  :after_lines => [ "3", "4", "5" ]
                }, # section
              ] # sections
            }, # chunk
            {
              :range =>
              {
                :was => { :start_line => 8, :size => 6 },
                :now => { :start_line => 8, :size => 6 },
              },
              :before_lines => [ "8", "9", "10" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "11" ],
                  :added_lines   => [ "11a" ],
                  :after_lines => [ "12", "13" ]
                }, # section
              ] # sections              
            }
          ] # chunks
    } # expected
    
    assert_equal expected, GitDiffParser.new(lines).parse
    
  end
  
  #-----------------------------------------------------
  
  def test_diff_on_first_and_last_line_in_two_chunks

lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 0719398..2943489 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -1,4 +1,4 @@
-1
+1a
 2
 3
 4
@@ -6,4 +6,4 @@
 6
 7
 8
-9
+9a
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 0719398..2943489 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 4 },
                :now => { :start_line => 1, :size => 4 },
              },
              :before_lines => [ ],
              :sections =>
              [
                {
                  :deleted_lines => [ "1" ],
                  :added_lines   => [ "1a" ],
                  :after_lines => [ "2", "3", "4" ]
                }, # section
              ] # sections
            }, # chunk
            {
              :range =>
              {
                :was => { :start_line => 6, :size => 4 },
                :now => { :start_line => 6, :size => 4 },
              },
              :before_lines => [ "6", "7", "8" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "9" ],
                  :added_lines   => [ "9a" ],
                  :after_lines => [ ]
                }, # section
              ] # sections              
            }
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse
    
  end
  
  #-----------------------------------------------------
  
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
\\ No newline at end of file
+p Time.now
\\ No newline at end of file
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
\\ No newline at end of file
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

