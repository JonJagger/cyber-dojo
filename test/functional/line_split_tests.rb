require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/line_split_tests.rb

class LineSplitTests < Test::Unit::TestCase

  def test_retain_lines_between_newlines    
    assert_equal [], "\n\n".split("\n")
    assert_equal [ "", "" ], line_split("\n\n")
  end

end


