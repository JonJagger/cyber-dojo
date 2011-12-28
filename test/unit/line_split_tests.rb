require File.dirname(__FILE__) + '/../test_helper'
require 'Utils'

# > ruby test/functional/line_split_tests.rb

class LineSplitTests < Test::Unit::TestCase

  def test_retain_lines_between_newlines
    # regular split doesn't do what I need    
    assert_equal [ ], "\n\n".split("\n")
    # So I have to roll my own...
    assert_equal [ "", "" ], line_split("\n\n")
  end

  def test_doesnt_add_extra_split_if_string_ends_in_newline
    assert_equal ["a"], line_split("a")
    assert_equal ["a"], line_split("a"+"\n")
    
    assert_equal ["a","b"], line_split("a"+"\n"+"b")
    assert_equal ["a","b"], line_split("a"+"\n"+"b"+"\n")
    
    assert_equal [""], line_split("")
    assert_equal [""], line_split("\n")
    assert_equal ["",""], line_split("\n"+"\n")
  end
  
  def test_splits_nil
    assert_equal [ ], line_split(nil)  
  end
  
end


