require File.dirname(__FILE__) + '/../test_helper'
require 'recent_helper'

class RecentTests < ActionController::TestCase

  include RecentHelper
  
  test "when array is empty result is empty" do
    empty = []
    assert_equal [], recent(empty, 0)
    assert_equal [], recent(empty, 5)
  end

  test "elements at front of array are dropped if n is less than array length" do
    array = [1,2,3,4]
    assert_equal [2,3,4], recent(array, 3)
    assert_equal [  3,4], recent(array, 2)
    assert_equal [    4], recent(array, 1)
  end

  test "whole array is returned if n is greater than or equal to array length" do
    array = [1,2,3,4]
    assert_equal [1,2,3,4], recent(array, 4)
    assert_equal [1,2,3,4], recent(array, 5)
    assert_equal [1,2,3,4], recent(array, 6)    
  end

end


