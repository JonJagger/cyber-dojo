require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionView::TestCase

  include TrafficLightHelper    
  
  test "tool tip" do
    assert_equal "Show hippo's diff 1 <-> 2 (2012 May 1, 23:20:45)",
      tool_tip('hippo', make_inc)
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def width
    18
  end
  
  def height
    55
  end
  
  def make_inc
    { :number => 2, :time => [2012,5,1,23,20,45], :colour => :red }
  end
  
end
