require File.dirname(__FILE__) + '/../test_helper'
require 'make_time_helper'

class MakeTimeTests < ActionView::TestCase

  include MakeTimeHelper
  
  class FakeTime
    def year; 1966; end
    def month; 11; end
    def day; 23; end
    def hour; 8; end
    def min; 45; end
    def sec; 59; end
  end
  
  test "make_time" do
    expected = [1966,11,23,8,45,59]
    assert_equal expected, make_time(FakeTime.new)
  end
  
end


