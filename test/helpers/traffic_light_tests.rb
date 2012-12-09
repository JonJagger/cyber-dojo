require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionController::TestCase

  include TrafficLightHelper

  test "revert traffic light red when revert_tag is nil" do
    inc = make_inc
    inc[:colour] = :red
    inc[:number] = 45
    inc[:revert_tag] = nil
    expected =
      "<span title='Revert to traffic-light 45 (red)'>" +
        "<img src='/images/traffic_light_red.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end

  test "revert traffic light red " do
    inc = make_inc
    inc[:colour] = :red
    inc[:number] = 45
    expected =
      "<span title='Revert to traffic-light 45 (red)'>" +
        "<img src='/images/traffic_light_red.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end
    
  test "revert traffic light amber " do
    inc = make_inc
    inc[:colour] = :amber
    inc[:number] = 45
    expected =
      "<span title='Revert to traffic-light 45 (amber)'>" +
        "<img src='/images/traffic_light_amber.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end

  test "revert traffic light green " do
    inc = make_inc
    inc[:colour] = :green
    inc[:number] = 45
    expected =
      "<span title='Revert to traffic-light 45 (green)'>" +
        "<img src='/images/traffic_light_green.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "reverted traffic light red " do
    inc = make_inc
    inc[:colour] = :red
    inc[:number] = 99
    inc[:revert_tag] = 23
    expected =
      "<span title='Revert to traffic-light 99 (red)'>" +
        "<img src='/images/traffic_light_red_revert.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end
  

  test "reverted traffic light amber " do
    inc = make_inc
    inc[:colour] = :amber
    inc[:number] = 67
    inc[:revert_tag] = 23
    expected =
      "<span title='Revert to traffic-light 67 (amber)'>" +
        "<img src='/images/traffic_light_amber_revert.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end


  test "reverted traffic light green " do
    inc = make_inc
    inc[:colour] = :green
    inc[:number] = 82
    inc[:revert_tag] = 23
    expected =
      "<span title='Revert to traffic-light 82 (green)'>" +
        "<img src='/images/traffic_light_green_revert.png' border='0' width='20' height='65'/>" +
      "</span>"
    assert_equal expected, revert_traffic_light(inc)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "unlinked traffic light red" do
    inc = make_inc
    inc[:colour] = :red
    expected =
      "<span title='2012 May 1, 23:20:45'>" +    
      "<img src='/images/traffic_light_red.png' border='0' width='#{width}' height='#{height}'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "unlinked traffic light amber" do
    inc = make_inc
    inc[:colour] = :amber
    expected =
      "<span title='2012 May 1, 23:20:45'>" +    
      "<img src='/images/traffic_light_amber.png' border='0' width='#{width}' height='#{height}'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  test "unlinked traffic light green" do
    inc = make_inc
    inc[:colour] = :green
    expected =
      "<span title='2012 May 1, 23:20:45'>" +
      "<img src='/images/traffic_light_green.png' border='0' width='#{width}' height='#{height}'/>" +
      "</span>"
    assert_equal expected, unlinked_traffic_light(inc) 
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "tool tip" do
    assert_equal 'Show the diff of hippo traffic-light #2 (2012 May 1, 23:20:45)',
      tool_tip('hippo',make_inc)
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def width
    20
  end
  
  def height
    65
  end
  
  def make_inc
    { :number => 2, :time => [2012,5,1,23,20,45], :colour => :red }
  end
  
end
