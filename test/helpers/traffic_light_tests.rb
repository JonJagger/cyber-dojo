require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionController::TestCase

  include TrafficLightHelper

  test "unlinked traffic light red" do
    inc = make_inc
    inc[:outcome] = :red
    expected =
      "<span title='2012 May 1, 23:20:45'>" +    
      "<img src='/images/traffic-light-red.png' border='0' width='#{width}' height='#{height}'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "unlinked traffic light amber" do
    inc = make_inc
    inc[:outcome] = :amber
    expected =
      "<span title='2012 May 1, 23:20:45'>" +    
      "<img src='/images/traffic-light-amber.png' border='0' width='#{width}' height='#{height}'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "unlinked traffic light green" do
    inc = make_inc
    inc[:outcome] = :green
    expected =
      "<span title='2012 May 1, 23:20:45'>" +
      "<img src='/images/traffic-light-green.png' border='0' width='#{width}' height='#{height}'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "tool tip" do
    assert_equal 'Show the diff of traffic-light #2 (2012 May 1, 23:20:45)', tool_tip(make_inc)
  end
  
  def width
    26
  end
  
  def height
    78
  end
  
  def make_inc
    { :number => 2, :time => [2012,5,1,23,20,45] }
  end
  
end
