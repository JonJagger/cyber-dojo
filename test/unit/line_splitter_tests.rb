require File.dirname(__FILE__) + '/../test_helper'
require 'LineSplitter'

# > ruby test/unit/line_splitter_tests.rb

class LineSplitterTests < ActionController::TestCase

  include LineSplitter
  
  test "retain lines between newlines" do
    # regular split doesn't do what I need    
    assert_equal [ ], "\n\n".split("\n")
    # So I have to roll my own...
    assert_equal [ "", "" ], line_split("\n\n")
  end

  test "doesnt add extra split if string ends in newline" do
    assert_equal ["a"], line_split("a")
    assert_equal ["a"], line_split("a"+"\n")
    
    assert_equal ["a","b"], line_split("a"+"\n"+"b")
    assert_equal ["a","b"], line_split("a"+"\n"+"b"+"\n")
    
    assert_equal [""], line_split("")
    assert_equal [""], line_split("\n")
    assert_equal ["",""], line_split("\n"+"\n")
  end
  
  test "splitting nil is an empty array" do
    assert_equal [ ], line_split(nil)  
  end
  
end
