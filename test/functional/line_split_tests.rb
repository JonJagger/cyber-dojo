require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/line_split_tests.rb

class LineSplitTests < Test::Unit::TestCase

  def test_retain_lines_between_newlines
    # regular split doesn't do what I need    
    assert_equal [], "\n\n".split("\n")
    # So I have to roll my own...
    assert_equal [ "", "" ], line_split("\n\n")
  end

end


