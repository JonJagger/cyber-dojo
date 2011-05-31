require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/git_diff_builder_tests.rb

class GitDiffBuilder

  def initialize
  end
  
  def build(diff, lines)

    the_diff =
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

    result = []
    
    line_number = 1    
    
    from = 0    
    chunk = the_diff[:chunks][0]
    range = chunk[:range]
    to = range[:was][:start_line] + chunk[:before_lines].length - 1
    
    line_number = fill(result, :same, lines, from, to, line_number)
    
    sections = chunk[:sections]
    section = sections[0]
    
    deleted_lines = section[:deleted_lines]
    from = 0
    to = deleted_lines.length
    line_number = fill(result, :deleted, deleted_lines, from, to, line_number)
    
    added_lines = section[:added_lines]
    from = 0
    to = added_lines.length
    line_number = fill(result, :added, added_lines, from, to, line_number)

    after_lines = section[:after_lines]
    from = 0
    to = after_lines.length
    line_number = fill(result, :same, after_lines, from, to, line_number)    
    
    last_lines = lines[line_number-1..lines.length]   
    from = 0
    to = last_lines.length
    line_number = fill(result, :same, last_lines, from, to, line_number)
    
    result
  end
  
private

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

  def test_build_one_chunk_with_one_sections
    
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


