require 'test_helper'
require 'recent_helper'

# > cd cyberdojo/test
# > ruby functional/recent_tests.rb

class RecentTests < ActionController::TestCase

  include RecentHelper
  
  def test_when_array_is_empty_result_is_empty
    empty = []
    assert_equal [], recent(empty, 0)
    assert_equal [], recent(empty, 5)
  end

  def test_elements_at_front_of_array_are_dropped_if_n_is_less_than_array_length
    array = [1,2,3,4]
    assert_equal [2,3,4], recent(array, 3)
    assert_equal [  3,4], recent(array, 2)
    assert_equal [    4], recent(array, 1)
  end

  def test_whole_array_is_returned_if_n_is_greater_than_or_equal_to_array_length
    array = [1,2,3,4]
    assert_equal [1,2,3,4], recent(array, 4)
    assert_equal [1,2,3,4], recent(array, 5)
    assert_equal [1,2,3,4], recent(array, 6)    
  end

end


