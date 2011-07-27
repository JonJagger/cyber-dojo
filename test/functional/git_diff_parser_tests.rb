require 'test_helper'
require 'GitDiffParser'

# > cd cyberdojo/test
# > ruby functional/git_diff_parser_tests.rb

class GitDiffParserTests < ActionController::TestCase 

  include GitDiff

  #-----------------------------------------------------
   
  def test_parse_diff_for_filename_ending_in_tab_removes_the_tab
    was_line =  '--- a/sandbox/ab cd'
    assert_equal 'a/sandbox/ab cd', 
      GitDiffParser.new(was_line + "\t").parse_was_filename    
  end
  
  #-----------------------------------------------------
  
  def test_parse_diff_for_filename_with_space_in_its_name
    was_line =  '--- a/sandbox/ab cd'
    assert_equal 'a/sandbox/ab cd', 
      GitDiffParser.new(was_line).parse_was_filename
  end
    
  #-----------------------------------------------------

  def test_parse_diff_for_deleted_file
    was_line =  '--- a/sandbox/xxx'
    assert_equal 'a/sandbox/xxx', 
      GitDiffParser.new(was_line).parse_was_filename

    now_line = '+++ /dev/null'
    assert_equal '/dev/null',
      GitDiffParser.new(now_line).parse_now_filename
  end
  
  #-----------------------------------------------------
  
  def test_parse_diff_for_new_file
    was_line =  '--- /dev/null'
    assert_equal '/dev/null', 
      GitDiffParser.new(was_line).parse_was_filename

    now_line = '+++ b/sandbox/untitled_6TJ'
    assert_equal 'b/sandbox/untitled_6TJ',
      GitDiffParser.new(now_line).parse_now_filename
  end
  
  #-----------------------------------------------------
  
  def test_parse_diff_deleted_file
    
lines = <<HERE
diff --git a/sandbox/original b/sandbox/original
deleted file mode 100644
index e69de29..0000000
HERE

expected =
{
  'a/sandbox/original' =>
  {
    :prefix_lines => 
    [
        "diff --git a/sandbox/original b/sandbox/original",
        "deleted file mode 100644",
        "index e69de29..0000000",
    ],
    :was_filename => 'a/sandbox/original',
    :now_filename => '/dev/null',
    :chunks => []
  }
}

    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end
  
  #-----------------------------------------------------
  
  def test_parse_diff_for_renamed_but_unchanged_file
    
lines = <<HERE
diff --git a/sandbox/oldname b/sandbox/newname
similarity index 100%
rename from sandbox/oldname
rename to sandbox/newname
HERE

expected =
{
  'b/sandbox/newname' =>
  {
    :prefix_lines => 
    [
        "diff --git a/sandbox/oldname b/sandbox/newname",
        "similarity index 100%",
        "rename from sandbox/oldname",
        "rename to sandbox/newname",
    ],
    :was_filename => 'a/sandbox/oldname',
    :now_filename => 'b/sandbox/newname',
    :chunks => []
  }
}

    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end
    
  #-----------------------------------------------------
  
  def test_parse_diff_for_renamed_and_changed_file
    
lines = <<HERE
diff --git a/sandbox/instructions b/sandbox/instructions_new
similarity index 87%
rename from sandbox/instructions
rename to sandbox/instructions_new
index e747436..83ec100 100644
--- a/sandbox/instructions
+++ b/sandbox/instructions_new
@@ -6,4 +6,4 @@ For example, the potential anagrams of "biro" are
 biro bior brio broi boir bori
 ibro ibor irbo irob iobr iorb
 rbio rboi ribo riob roib robi
-obir obri oibr oirb orbi orib
+obir obri oibr oirb orbi oribx
HERE

expected_diff = 
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/instructions b/sandbox/instructions_new",
            "similarity index 87%",
            "rename from sandbox/instructions",
            "rename to sandbox/instructions_new",
            "index e747436..83ec100 100644"
          ],
          :was_filename => 'a/sandbox/instructions',
          :now_filename => 'b/sandbox/instructions_new',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 6, :size => 4 },
                :now => { :start_line => 6, :size => 4 },
              },
              :before_lines => 
                [ 
                  "biro bior brio broi boir bori",
                  "ibro ibor irbo irob iobr iorb",
                  "rbio rboi ribo riob roib robi"
                ],
              :sections =>
              [
                {
                  :deleted_lines => [ "obir obri oibr oirb orbi orib" ],
                  :added_lines   => [ "obir obri oibr oirb orbi oribx" ],
                  :after_lines => []
                }, # section
              ] # sections
            } # chunk
          ] # chunks  
    }

    expected = { 'b/sandbox/instructions_new' => expected_diff }
    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end
  
  #-----------------------------------------------------
  
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
\\ No newline at end of file
HERE
    
    expected_diff_1 =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 896ddd8..2c8d1b8 100644"
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 7 },
                :now => { :start_line => 1, :size => 7 },
              },
              :before_lines => [ "1", "2", "3"],
              :sections =>
              [
                {
                  :deleted_lines => [ "4" ],
                  :added_lines   => [ "4a" ],
                  :after_lines => [ "5", "6", "7" ]
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
        :was_filename => 'a/sandbox/other',
        :now_filename => 'b/sandbox/other',
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
      'b/sandbox/lines' => expected_diff_1,
      'b/sandbox/other' => expected_diff_2
    }
    
    parser = GitDiffParser.new(lines)    
    assert_equal expected, parser.parse_all

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
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
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
    
    assert_equal expected, GitDiffParser.new(lines).parse_one
    
  end
  
  #-----------------------------------------------------
  
  def test_diff_one_chunk_one_section
lines = <<HERE
@@ -1,4 +1,4 @@
-1
+1a
 2
 3
 4
HERE

    expected =
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
      } # chunk

    assert_equal expected, 
      GitDiffParser.new(lines).parse_chunk_one
  end

  #-----------------------------------------------------

  def test_diff_one_chunk_two_sections
lines = <<HERE
@@ -1,8 +1,8 @@
 1
 2
-3
+3a
 4
-5
+5a
 6
 7
 8
HERE

    expected =
      [
        {
          :range =>
          {
            :was => { :start_line => 1, :size => 8 },
            :now => { :start_line => 1, :size => 8 },
          },
          :before_lines => [ "1", "2" ],
          :sections =>
          [
            {
              :deleted_lines => [ "3" ],
              :added_lines   => [ "3a" ],
              :after_lines => [ "4" ]
            }, # section
            {
              :deleted_lines => [ "5" ],
              :added_lines   => [ "5a" ],
              :after_lines => [ "6", "7", "8" ]
            }, # section            
          ] # sections
        } # chunk
      ] # chunks
    assert_equal expected, 
      GitDiffParser.new(lines).parse_chunk_all
    
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
      :was_filename => 'a/sandbox/gapper.rb',
      :now_filename => 'b/sandbox/gapper.rb',
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
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  def test_find_copies_harder_finds_a_rename
lines = <<HERE
diff --git a/sandbox/oldname b/sandbox/newname
similarity index 99%
rename from sandbox/oldname
rename to sandbox/newname
index afcb4df..c0f407c 100644
HERE

    expected = 
      [
        "diff --git a/sandbox/oldname b/sandbox/newname",
        "similarity index 99%",
        "rename from sandbox/oldname",
        "rename to sandbox/newname",
        "index afcb4df..c0f407c 100644"
      ]
    assert_equal expected, 
      GitDiffParser.new(lines).parse_prefix_lines
  end
  
  #-----------------------------------------------------

  def test_no_deleted_line
lines = <<HERE
+p Timw.now
+p Time.now
HERE

    expected = []
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines      
  end

  #-----------------------------------------------------

  def test_no_added_line
lines = <<HERE
 p Timw.now
 p Time.now
HERE

    expected = []
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines      
  end

  #-----------------------------------------------------

  def test_single_deleted_line
lines = <<HERE
-p Timw.now
+p Time.now
HERE

    expected =
      [
        'p Timw.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines  
  end

  #-----------------------------------------------------

  def test_single_added_line
lines = <<HERE
+p Time.now
 common line
HERE

    expected =
      [
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines  
  end

  #-----------------------------------------------------

  def test_single_deleted_line_with_following_newline_at_eof
lines = <<HERE
-p Timw.now
\\ No newline at end of file'
HERE

    expected =
      [
        'p Timw.now',
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines  
  end

  #-----------------------------------------------------

  def test_single_added_line_with_following_newline_at_eof
lines = <<HERE
+p Timw.now
\\ No newline at end of file'
HERE

    expected =
      [
        'p Timw.now',
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines      
  end

  #-----------------------------------------------------
  
  def test_two_deleted_lines
lines = <<HERE
-p Timw.now
-p Time.now
HERE

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines  
  end

  #-----------------------------------------------------

  def test_two_added_lines
lines = <<HERE
+p Timw.now
+p Time.now
HERE

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
    GitDiffParser.new(lines).parse_added_lines      
  end

  #-----------------------------------------------------

  def test_two_deleted_lines_with_following_newline_at_eof
lines = <<HERE
-p Timw.now
-p Time.now
\\ No newline at end of file
HERE

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines      
  end

  #-----------------------------------------------------

  def test_two_added_lines_with_following_newline_at_eof
lines = <<HERE
+p Timw.now
+p Time.now
\\ No newline at end of file
HERE

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines          
  end

  #-----------------------------------------------------

  def test_diff_two_chunks

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
        :was_filename => 'a/sandbox/test_gapper.rb',
        :now_filename => 'b/sandbox/test_gapper.rb',
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
    assert_equal expected, GitDiffParser.new(lines).parse_one

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
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
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
    assert_equal expected, GitDiffParser.new(lines).parse_one

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
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
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
    assert_equal expected, GitDiffParser.new(lines).parse_one
    
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
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
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
    assert_equal expected, GitDiffParser.new(lines).parse_one
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
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
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
    assert_equal expected, GitDiffParser.new(lines).parse_one
    
  end

end


