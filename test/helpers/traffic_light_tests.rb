require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionController::TestCase

  include TrafficLightHelper

  test "unlinked traffic light red" do
    expected = 
      "<img src='/images/traffic-light-red.png' border='0' width='#{width}' height='#{height}'/>"
    assert_equal expected, unlinked_traffic_light({ :outcome => :red }) 
  end
  
  test "unlinked traffic light amber" do
    expected = 
      "<img src='/images/traffic-light-amber.png' border='0' width='#{width}' height='#{height}'/>"
    assert_equal expected, unlinked_traffic_light({ :outcome => :amber }) 
  end
  
  test "unlinked traffic light green" do
    expected = 
      "<img src='/images/traffic-light-green.png' border='0' width='#{width}' height='#{height}'/>"
    assert_equal expected, unlinked_traffic_light({ :outcome => :green }) 
  end
  
  test "tool tip" do
    inc_number = 2
    assert_equal 'Open a diff page (2)', tool_tip(inc_number)
  end
  
  def width
    26
  end
  
  def height
    78
  end
  
end
