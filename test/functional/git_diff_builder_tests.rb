require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/git_diff_builder_tests.rb

class GitDiffBuilder

  def initialize
  end
  
  def build(diff, lines)
    
    result = []
    
    line_number = 1    
    
    from = 0    
    chunk = diff[:chunks][0]
    range = chunk[:range]
    to = range[:was][:start_line] + chunk[:before_lines].length - 1
    
    line_number = fill(result, :same, lines, from, to, line_number)
    
    chunk[:sections].each do |section|
      line_number = build_section(result, section, line_number)
    end
    
    last_lines = lines[line_number-1..lines.length]   
    from = 0
    to = last_lines.length
    line_number = fill(result, :same, last_lines, from, to, line_number)
    
    result
  end
  
private

  def build_section(result, section, line_number)
    line_number = fill_all(result, :deleted, section[:deleted_lines], line_number)
    line_number = fill_all(result, :added, section[:added_lines], line_number)
    line_number = fill_all(result, :same, section[:after_lines], line_number)
  end

  def fill_all(result, type, lines, line_number)
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

#----------------------------------------------------

class GitDiffBuilderTests < ActionController::TestCase

  
  
  #- - - - - - - - - - - - - - - - - - - - - - -  
  
  def test_build_one_chunk_with_two_section_each_with_one_line_added_and_one_line_deleted

diff_lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 535d2b0..a173ef1 100644
--- a/sandbox/lines
+++ b/sandbox/lines
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

    expected_diff =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 535d2b0..a173ef1 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
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
    } # expected
    assert_equal expected_diff, GitDiffParser.new(diff_lines).parse

source_lines = <<HERE
1
2
3a
4
5a
6
7
8
HERE

    builder = GitDiffBuilder.new()
    source_diff = builder.build(expected_diff, source_lines.split("\n"))
    
    expected_source_diff =
    [
      { :line => "1", :type => :same, :number => 1 },
      { :line => "2", :type => :same, :number => 2 },
      { :line => "3", :type => :deleted },
      { :line => "3a", :type => :added, :number => 3 },      
      { :line => "4", :type => :same, :number => 4 },  
      { :line => "5", :type => :deleted },
      { :line => "5a", :type => :added, :number => 5 },      
      { :line => "6", :type => :same, :number => 6 },
      { :line => "7", :type => :same, :number => 7 },
      { :line => "8", :type => :same, :number => 8 },          
    ]
    
    assert_equal expected_source_diff, source_diff

  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -  

  def test_build_one_chunk_with_one_section_with_only_lines_added
    
diff_lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 06e567b..59e88aa 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -1,6 +1,9 @@
 1
 2
 3
+3a1
+3a2
+3a3
 4
 5
 6
HERE
  
    expected_diff =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 06e567b..59e88aa 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 6 },
                :now => { :start_line => 1, :size => 9 },
              },
              :before_lines => [ "1", "2", "3" ],
              :sections =>
              [
                {
                  :deleted_lines => [ ],
                  :added_lines   => [ "3a1", "3a2", "3a3" ],
                  :after_lines => [ "4", "5", "6" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected_diff, GitDiffParser.new(diff_lines).parse

source_lines = <<HERE
1
2
3
3a1
3a2
3a3
4
5
6
7
HERE
  
    builder = GitDiffBuilder.new()
    source_diff = builder.build(expected_diff, source_lines.split("\n"))
    
    expected_source_diff =
    [
      { :line => "1", :type => :same, :number => 1 },
      { :line => "2", :type => :same, :number => 2 },
      { :line => "3", :type => :same, :number => 3 },      
      { :line => "3a1", :type => :added, :number => 4 },
      { :line => "3a2", :type => :added, :number => 5 },
      { :line => "3a3", :type => :added, :number => 6 },
      { :line => "4", :type => :same, :number => 7 },
      { :line => "5", :type => :same, :number => 8 },
      { :line => "6", :type => :same, :number => 9 },
      { :line => "7", :type => :same, :number => 10 },           
    ]
    
    assert_equal expected_source_diff, source_diff
    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -  
  
  def test_build_one_chunk_with_one_section_with_only_lines_deleted
    
diff_lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 0b669b6..a972632 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -2,8 +2,6 @@
 2
 3
 4
-5
-6
 7
 8
 9
HERE

    expected_diff =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 0b669b6..a972632 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 2, :size => 8 },
                :now => { :start_line => 2, :size => 6 },
              },
              :before_lines => [ "2", "3", "4" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "5", "6" ],
                  :added_lines   => [ ],
                  :after_lines => [ "7", "8", "9" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected_diff, GitDiffParser.new(diff_lines).parse

source_lines = <<HERE
1
2
3
4
7
8
9
10
HERE
  
    builder = GitDiffBuilder.new()
    source_diff = builder.build(expected_diff, source_lines.split("\n"))
    
    expected_source_diff =
    [
      { :line => "1", :type => :same, :number => 1 },
      { :line => "2", :type => :same, :number => 2 },
      { :line => "3", :type => :same, :number => 3 },      
      { :line => "4", :type => :same, :number => 4 },      
      { :line => "5", :type => :deleted },
      { :line => "6", :type => :deleted },
      { :line => "7", :type => :same, :number => 5 },
      { :line => "8", :type => :same, :number => 6 },
      { :line => "9", :type => :same, :number => 7 },
      { :line => "10", :type => :same, :number => 8 },           
    ]
    
    assert_equal expected_source_diff, source_diff

  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -  
  
  def test_build_one_chunk_with_one_section_with_more_lines_deleted_than_added

diff_lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 08fe19c..1f8695e 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -3,9 +3,7 @@
 3
 4
 5
-6
-7
-8
+7a
 9
 10
 11
HERE

    expected_diff =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 08fe19c..1f8695e 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 3, :size => 9 },
                :now => { :start_line => 3, :size => 7 },
              },
              :before_lines => [ "3", "4", "5" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "6", "7", "8" ],
                  :added_lines   => [ "7a" ],
                  :after_lines => [ "9", "10", "11" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected_diff, GitDiffParser.new(diff_lines).parse

source_lines = <<HERE
1
2
3
4
5
7a
9
10
11
12
HERE

    builder = GitDiffBuilder.new()
    source_diff = builder.build(expected_diff, source_lines.split("\n"))
    
    expected_source_diff =
    [
      { :line => "1", :type => :same, :number => 1 },
      { :line => "2", :type => :same, :number => 2 },
      { :line => "3", :type => :same, :number => 3 },
      { :line => "4", :type => :same, :number => 4 },
      { :line => "5", :type => :same, :number => 5 },
      { :line => "6", :type => :deleted },
      { :line => "7", :type => :deleted },
      { :line => "8", :type => :deleted },      
      { :line => "7a", :type => :added, :number => 6 },
      { :line => "9", :type => :same, :number => 7 },
      { :line => "10", :type => :same, :number => 8 },
      { :line => "11", :type => :same, :number => 9 },
      { :line => "12", :type => :same, :number => 10 },           
    ]
    
    assert_equal expected_source_diff, source_diff
    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -
  
  def test_build_one_chunk_with_one_section_with_more_lines_added_than_deleted
  
diff_lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 8e435da..a787223 100644
--- a/sandbox/lines
+++ b/sandbox/lines
@@ -3,7 +3,8 @@
 3
 4
 5
-6
+6a
+6b
 7
 8
 9
HERE
    
    expected_diff =
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 8e435da..a787223 100644"
          ],
        :was_filename => 'sandbox/lines',
        :now_filename => 'sandbox/lines',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 3, :size => 7 },
                :now => { :start_line => 3, :size => 8 },
              },
              :before_lines => [ "3", "4", "5" ],
              :sections =>
              [
                {
                  :deleted_lines => [ "6" ],
                  :added_lines   => [ "6a", "6b" ],
                  :after_lines => [ "7", "8", "9" ]
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected_diff, GitDiffParser.new(diff_lines).parse

source_lines = <<HERE
1
2
3
4
5
6a
6b
7
8
9
10
11
12
13
HERE
    
    builder = GitDiffBuilder.new()
    source_diff = builder.build(expected_diff, source_lines.split("\n"))
    
    expected_source_diff =
    [
      { :line => "1", :type => :same, :number => 1 },
      { :line => "2", :type => :same, :number => 2 },
      { :line => "3", :type => :same, :number => 3 },
      { :line => "4", :type => :same, :number => 4 },
      { :line => "5", :type => :same, :number => 5 },
      { :line => "6", :type => :deleted },
      { :line => "6a", :type => :added, :number => 6 },
      { :line => "6b", :type => :added, :number => 7 },
      { :line => "7", :type => :same, :number => 8 },
      { :line => "8", :type => :same, :number => 9 },
      { :line => "9", :type => :same, :number => 10 },
      { :line => "10", :type => :same, :number => 11 },
      { :line => "11", :type => :same, :number => 12 },
      { :line => "12", :type => :same, :number => 13 },
      { :line => "13", :type => :same, :number => 14 },      
      
    ]
    assert_equal expected_source_diff, source_diff
    
  end  

  #- - - - - - - - - - - - - - - - - - - - - - -
  
  def test_build_one_chunk_with_one_section_with_one_line_deleted_and_one_line_added
    
diff_lines = <<HERE
diff --git a/sandbox/lines b/sandbox/lines
index 5ed4618..aad3f67 100644
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
HERE

    expected_diff =
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
                } # section
              ] # sections
            } # chunk      
          ] # chunks
    } # expected
    assert_equal expected_diff, GitDiffParser.new(diff_lines).parse
    
source_lines = <<HERE
1
2
3
4
5
6
7
8a
9
10
11
12
13
HERE

    expected_split_lines = 
    [
      "1", "2", "3", "4", "5", "6", "7", "8a", "9", "10", "11", "12", "13"
    ]
    split_lines = source_lines.split("\n")
    assert_equal expected_split_lines, split_lines

    builder = GitDiffBuilder.new()
    source_diff = builder.build(expected_diff, split_lines)
    
    expected_source_diff =
    [
      { :line => "1", :type => :same, :number => 1 },
      { :line => "2", :type => :same, :number => 2 },
      { :line => "3", :type => :same, :number => 3 },
      { :line => "4", :type => :same, :number => 4 },
      { :line => "5", :type => :same, :number => 5 },
      { :line => "6", :type => :same, :number => 6 },
      { :line => "7", :type => :same, :number => 7 },
      { :line => "8", :type => :deleted },
      { :line => "8a", :type => :added, :number => 8 },
      { :line => "9", :type => :same, :number => 9 },
      { :line => "10", :type => :same, :number => 10 },
      { :line => "11", :type => :same, :number => 11 },
      { :line => "12", :type => :same, :number => 12 },
      { :line => "13", :type => :same, :number => 13 },      
      
    ]
    assert_equal expected_source_diff, source_diff
    
  end

end


