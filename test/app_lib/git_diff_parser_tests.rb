require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiffParser'

class GitDiffParserTests < ActionController::TestCase 

  include GitDiff

  test "lines are split" do
    lines = [ "a", "b" ]
    assert_equal lines, GitDiffParser.new(lines.join("\n")).lines
  end
   
  #-----------------------------------------------------
  
  test "parse diff for filename ending in tab removes the tab" do
    was_line =  '--- a/sandbox/ab cd'
    assert_equal 'a/sandbox/ab cd', 
      GitDiffParser.new(was_line + "\t").parse_was_filename    
  end
  
  #-----------------------------------------------------
  
  test "parse diff for filename with space in its name" do
    was_line =  '--- a/sandbox/ab cd'
    assert_equal 'a/sandbox/ab cd', 
      GitDiffParser.new(was_line).parse_was_filename
  end
    
  #-----------------------------------------------------

  test "parse diff for deleted file" do
    was_line =  '--- a/sandbox/xxx'
    assert_equal 'a/sandbox/xxx', 
      GitDiffParser.new(was_line).parse_was_filename

    now_line = '+++ /dev/null'
    assert_equal '/dev/null',
      GitDiffParser.new(now_line).parse_now_filename
  end
  
  #-----------------------------------------------------
  
  test "parse diff for new file" do
    was_line =  '--- /dev/null'
    assert_equal '/dev/null', 
      GitDiffParser.new(was_line).parse_was_filename

    now_line = '+++ b/sandbox/untitled_6TJ'
    assert_equal 'b/sandbox/untitled_6TJ',
      GitDiffParser.new(now_line).parse_now_filename
  end
  
  #-----------------------------------------------------
  
  test "here processing" do
    # backslash characters still have to be escaped in a here string
line = <<HERE
"\\\\was"
HERE
    assert_equal '"',  line[0].chr
    assert_equal "\\", line[1].chr
    assert_equal "\\", line[2].chr
    assert_equal "w",  line[3].chr
    assert_equal "a",  line[4].chr
    assert_equal "s",  line[5].chr
    assert_equal '"',  line[6].chr
  end
  
  #-----------------------------------------------------

  test "parse diff quoted filename with backslash" do
    filename = "\"\\\\was\""      
    expected = "\\was"
    actual = GitDiffParser.new("").unescaped(filename)
    assert_equal expected, actual    
  end
  
  #-----------------------------------------------------
  
  test "parse diff containing filename with backslash" do

lines = <<HERE
diff --git "a/sandbox/\\\\was_newfile_FIU" "b/sandbox/\\\\was_newfile_FIU"
deleted file mode 100644
index 21984c7..0000000
--- "a/sandbox/\\\\was_newfile_FIU"
+++ /dev/null
@@ -1 +0,0 @@
-Please rename me!
\\ No newline at end of file
HERE

expected =
{
  "a/sandbox/\\was_newfile_FIU" =>   # <------ single backslash
  {
    :prefix_lines => 
    [
        "diff --git \"a/sandbox/\\\\was_newfile_FIU\" \"b/sandbox/\\\\was_newfile_FIU\"",
        "deleted file mode 100644",
        "index 21984c7..0000000",
    ],
    :was_filename => "a/sandbox/\\was_newfile_FIU", # <------ single backslash
    :now_filename => '/dev/null',
    :chunks       => 
    [
      {
        :range =>
        {
          :now => { :size => 0, :start_line => 0 },
          :was => { :size => 1, :start_line => 1 }
        },          
        :sections => 
        [
          {
            :deleted_lines => [ "Please rename me!"],
            :added_lines   => [ ],
            :after_lines   => [ ]
          }
        ],
        :before_lines => [ ]
      }
    ]
  }
}

    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end
  
  #-----------------------------------------------------
  
  test "parse diff deleted file" do
    
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
    :chunks       => [ ]
  }
}

    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------

  test "parse another diff-form of a deleted file" do

lines = <<HERE
diff --git a/sandbox/untitled.rb b/sandbox/untitled.rb
deleted file mode 100644
index 5c4b3ab..0000000
--- a/sandbox/untitled.rb
+++ /dev/null
@@ -1,3 +0,0 @@
-def answer
-  42
-end
HERE

expected =
{
  'a/sandbox/untitled.rb' =>
  {
    :prefix_lines => 
    [
        "diff --git a/sandbox/untitled.rb b/sandbox/untitled.rb",
        "deleted file mode 100644",
        "index 5c4b3ab..0000000",
    ],
    :was_filename => 'a/sandbox/untitled.rb',
    :now_filename => '/dev/null',
    :chunks => 
    [
      {
        :range =>
        {
          :was =>
          {
            :start_line => 1,
            :size       => 3
          },
          :now =>
          {
            :start_line => 0,
            :size       => 0
          }
        },
        :before_lines => [ ],
        :sections     =>
        [
          {
          :deleted_lines => ["def answer", "  42", "end"],
          :added_lines   => [ ],
          :after_lines   => [ ]
          }
        ]
      }
    ]        
  }
}

    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

    assert_equal ["def answer","  42", "end"],
      actual['a/sandbox/untitled.rb'][:chunks][0][:sections][0][:deleted_lines]
      
    md = %r|^(.)/sandbox/(.*)|.match('a/sandbox/untitled.rb')
    assert_not_nil md
    assert_equal 'a', md[1]
    filename = md[2]
    assert_equal 'untitled.rb', filename
    
  end

  #-----------------------------------------------------

  test "parse diff for renamed but unchanged file and newname is quoted" do
lines = <<HERE
diff --git "a/sandbox/was_\\\\wa s_newfile_FIU" "b/sandbox/\\\\was_newfile_FIU"
similarity index 100%
rename from "sandbox/was_\\\\wa s_newfile_FIU"
rename to "sandbox/\\\\was_newfile_FIU"
HERE

expected = 
{
  'b/sandbox/\\was_newfile_FIU' => # <------ single backslash
  {
    :prefix_lines => 
    [
        "diff --git \"a/sandbox/was_\\\\wa s_newfile_FIU\" \"b/sandbox/\\\\was_newfile_FIU\"",
        "similarity index 100%",
        "rename from \"sandbox/was_\\\\wa s_newfile_FIU\"",
        "rename to \"sandbox/\\\\was_newfile_FIU\"",
    ],
    :was_filename => 'a/sandbox/was_\\wa s_newfile_FIU', # <------ single backslash
    :now_filename => 'b/sandbox/\\was_newfile_FIU', # <------ single backslash
    :chunks       => [ ]
  }
}
    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------
  
  test "parse diff for renamed but unchanged file" do
    
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
    :chunks       => [ ]
  }
}

    parser = GitDiffParser.new(lines)    
    actual = parser.parse_all
    assert_equal expected, actual

  end
    
  #-----------------------------------------------------
  
  test "parse diff for renamed and changed file" do
    
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
                  :after_lines   => [ ]
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
  
  test "parse diffs for two files" do

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
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 7 },
                :now => { :start_line => 1, :size => 7 },
              },
              :before_lines => [ "1", "2", "3"],
              :sections     =>
              [
                {
                  :deleted_lines => [ "4" ],
                  :added_lines   => [ "4a" ],
                  :after_lines   => [ "5", "6", "7" ]
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
              :sections     =>
              [
                {
                  :deleted_lines => [ "3", "4" ],
                  :added_lines   => [ "3a", "4a" ],
                  :after_lines   => [ "5", "6" ]
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

  test "parse range was and now size defaulted" do
    lines = "@@ -3 +5 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 1 },
      :now => { :start_line => 5, :size => 1 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------
  
  test "parse range was size defaulted" do
    lines = "@@ -3 +5,9 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 1 },
      :now => { :start_line => 5, :size => 9 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------

  test "parse range now size defaulted" do
    lines = "@@ -3,4 +5 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 4 },
      :now => { :start_line => 5, :size => 1 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end
  
  #-----------------------------------------------------
  
  test "parse range nothing defaulted" do
    lines = "@@ -3,4 +5,6 @@ suffix"
    expected = 
    {
      :was => { :start_line => 3, :size => 4 },
      :now => { :start_line => 5, :size => 6 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range   
  end

  #-----------------------------------------------------
  
  test "parse no newline at eof false" do
    lines = ' No newline at eof'
    parser = GitDiffParser.new(lines)

    assert_equal 0, parser.n
    parser.parse_newline_at_eof
    assert_equal 0, parser.n        
  end
  
  #-----------------------------------------------------

  test "parse no newline at eof true" do
    lines = '\\ No newline at end of file'
    parser = GitDiffParser.new(lines)

    assert_equal 0, parser.n
    parser.parse_newline_at_eof
    assert_equal 1, parser.n        
  end
  
  #-----------------------------------------------------
  
  test "two chunks with no newline at end of file" do
    
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
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 5 },
                :now => { :start_line => 1, :size => 5 },
              },
              :before_lines => [ "1" ],
              :sections     =>
              [
                {
                  :deleted_lines => [ "2" ],
                  :added_lines   => [ "2a" ],
                  :after_lines   => [ "3", "4", "5" ]
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
              :sections     =>
              [
                {
                  :deleted_lines => [ "11" ],
                  :added_lines   => [ "11a" ],
                  :after_lines   => [ "12", "13" ]
                }, # section
              ] # sections              
            }
          ] # chunks
    } # expected
    
    assert_equal expected, GitDiffParser.new(lines).parse_one
    
  end
  
  #-----------------------------------------------------
  
  test "diff one chunk one section" do
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
        :sections     =>
        [
          {
            :deleted_lines => [ "1" ],
            :added_lines   => [ "1a" ],
            :after_lines   => [ "2", "3", "4" ]
          }, # section
        ] # sections
      } # chunk

    assert_equal expected, 
      GitDiffParser.new(lines).parse_chunk_one
  end

  #-----------------------------------------------------

  test "diff one chunk two sections" do
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
          :sections     =>
          [
            {
              :deleted_lines => [ "3" ],
              :added_lines   => [ "3a" ],
              :after_lines   => [ "4" ]
            }, # section
            {
              :deleted_lines => [ "5" ],
              :added_lines   => [ "5a" ],
              :after_lines   => [ "6", "7", "8" ]
            }, # section            
          ] # sections
        } # chunk
      ] # chunks
    assert_equal expected, 
      GitDiffParser.new(lines).parse_chunk_all
    
  end
  
  #-----------------------------------------------------
  
  test "standard diff" do

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
      :chunks       => 
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

  test "find copies harder finds a rename" do
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

  test "no deleted line" do
lines = <<HERE
+p Timw.now
+p Time.now
HERE

    expected = [ ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines      
  end

  #-----------------------------------------------------

  test "no added line" do
lines = <<HERE
 p Timw.now
 p Time.now
HERE

    expected = [ ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines      
  end

  #-----------------------------------------------------

  test "single deleted line" do
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

  test "single added line" do
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

  test "single deleted line with following newline at eof" do
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

  test "single added line with following newline at eof" do
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
  
  test "two deleted lines" do
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

  test "two added lines" do
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

  test "two deleted lines with following newline at eof" do
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

  test "two added lines with following newline at eof" do
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

  test "diff two chunks" do

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
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 9, :size => 4 },
                :now => { :start_line => 9, :size => 3 },
              },
              :before_lines => [ ],
              :sections     =>
              [
                { :deleted_lines => [ "p Timw.now" ],
                  :added_lines   => [ "p Time.now" ],
                  :after_lines   => [ ]
                }
              ]
            },
            {
              :range =>
              {
                :was => { :start_line => 19, :size => 4 },
                :now => { :start_line => 19, :size => 3 },
              },
              :before_lines => [ ],
              :sections     =>
              [
                {
                  :deleted_lines => [ "q Timw.now" ],
                  :added_lines   => [ "q Time.now" ],
                  :after_lines   => [ ]
                }
              ]      
            }
          ]    
    }
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------
  
  test "when diffs are one line apart" do

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
        :chunks       =>
          [
            {
              :range =>
              { 
                :was => { :start_line => 5, :size => 9 },
                :now => { :start_line => 5, :size => 9 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections     =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines   => [ "9" ]
                },
                {
                  :deleted_lines => [ "10" ],
                  :added_lines   => [ "10a" ],
                  :after_lines   => [ "11", "12", "13" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------
  
  test "when diffs are 2 lines apart" do
    
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
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 10 },
                :now => { :start_line => 5, :size => 10 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections     =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines   => [ "9", "10" ]
                },
                {
                  :deleted_lines => [ "11" ],
                  :added_lines   => [ "11a" ],
                  :after_lines   => [ "12", "13", "14" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one
    
  end

  #-----------------------------------------------------

  test "when diffs are 6 lines apart" do
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
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 14 },
                :now => { :start_line => 5, :size => 14 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections     =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines   => [ "9", "10", "11", "12", "13", "14" ]
                },
                {
                  :deleted_lines => [ "15" ],
                  :added_lines   => [ "15a" ],
                  :after_lines   => [ "16", "17" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one
  end    
  
  #-----------------------------------------------------
  
  test "when diffs are seven lines apart" do
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
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 7 },
                :now => { :start_line => 5, :size => 7 },
              },
              :before_lines => [ "5", "6", "7" ],
              :sections     =>
              [
                {
                  :deleted_lines => [ "8" ],
                  :added_lines   => [ "8a" ],
                  :after_lines   => [ "9", "10", "11" ]
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
              :sections     =>
              [
                {
                  :deleted_lines => [ "16" ],
                  :added_lines   => [ "16a" ],
                  :after_lines   => [ "17", "18", "19" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one
    
  end

  #-----------------------------------------------------
  
  test "no_newline_at_end_of_file line at end of common section is gobbled" do
    # James Grenning has built his own cyber-dojo server
    # which he uses for training. He noticed that a file
    # called CircularBufferTests.cpp
    # changed between two traffic-lights but the diff-view
    # was not displaying the diff. He sent me a zip of the
    # avatars git repository and I confirmed that
    #   git diff 8 9 sandbox/CircularBufferTests.cpp
    # produced the following output
    
lines = <<HERE
diff --git a/sandbox/CircularBufferTest.cpp b/sandbox/CircularBufferTest.cpp
index 0ddb952..a397f48 100644
--- a/sandbox/CircularBufferTest.cpp
+++ b/sandbox/CircularBufferTest.cpp
@@ -35,3 +35,8 @@ TEST(CircularBuffer, EmptyAfterCreation)
 {
     CHECK_TRUE(CircularBuffer_IsEmpty(buffer));
 }
\\ No newline at end of file
+
+TEST(CircularBuffer, NotFullAfterCreation)
+{
+    CHECK_FALSE(CircularBuffer_IsFull(buffer));
+}
\\ No newline at end of file
HERE

    expected =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/CircularBufferTest.cpp b/sandbox/CircularBufferTest.cpp",
            "index 0ddb952..a397f48 100644"
          ],
        :was_filename => 'a/sandbox/CircularBufferTest.cpp',
        :now_filename => 'b/sandbox/CircularBufferTest.cpp',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 35, :size => 3 },
                :now => { :start_line => 35, :size => 8 },
              },
              :before_lines =>
              [
                "{",
                "    CHECK_TRUE(CircularBuffer_IsEmpty(buffer));",
                "}"
              ],
              :sections =>
              [
                {
                  :deleted_lines => [ ],
                  :added_lines   =>
                  [
                    "",
                    "TEST(CircularBuffer, NotFullAfterCreation)",
                    "{",
                    "    CHECK_FALSE(CircularBuffer_IsFull(buffer));",
                    "}"
                  ],
                  :after_lines => [ ]
                }
              ]
            }
          ] # chunks
    } # expected
    
    assert_equal expected, GitDiffParser.new(lines).parse_one    
  end

end


