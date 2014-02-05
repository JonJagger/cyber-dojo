require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionView::TestCase

  include TrafficLightHelper    
  
  test "tool tip" do
    assert_equal "Review hippo's<br>1 &harr; 2 diff<br>(2012 May 1, 23:20:45)",
      tool_tip('hippo', make_inc)
  end
  
  test "traffic_light_image" do
    expected = "<img src='/images/traffic_light_red.png'" +
               " alt='red traffic-light'" +
               " width='12'" +
               " height='38'/>"
    color = 'red'
    width='12'
    height='38'
    actual = traffic_light_image(color,width,height)
    assert_equal expected, actual
  end
  
  test "no_diff_avatar_image" do
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar_name = 'hippo'
    light = { :number => 23 }
    max_lights = 45
    expected = "" +
      "<div" +
      " class='tipped diff-traffic-light'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='23'" +
      " data-now-tag='23'" +
      " data-max-tag='45'>" +
      "<div class='tooltip'>" +
      "Show hippo's<br>current code" +
      "</div>" +
      "<img src='/images/avatars/hippo.jpg'" +
          " alt='hippo'" +
          " width='45'" +
          " height='45'/>" +
        "</div>"
    actual = no_diff_avatar_image(kata,avatar_name,light,max_lights)
    assert_equal expected, actual
  end
  
  test "diff_traffic_light" do
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar_name = 'hippo'
    light = { :number => 23, :colour => 'red', :time => [2012,5,1,23,20,45] }
    max_lights = 45
    expected = "" +
      "<div" +
      " class='tipped diff-traffic-light'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='22'" +
      " data-now-tag='23'" +
      " data-max-tag='45'>" +
      "<div class='tooltip'>" +      
      "Review hippo's<br>22 &harr; 23 diff<br>(2012 May 1, 23:20:45)" +
      "</div>" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='20'" +
          " height='62'/>" +
      "</div>"
    actual = diff_traffic_light(kata,avatar_name,light,max_lights)
    assert_equal expected, actual    
  end
  
  test "unlinked_traffic_light with defaults" do
    expected = "" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='20'" +
          " height='62'/>"
    inc = { :colour => 'red' }
    actual = unlinked_traffic_light(inc)
    assert_equal expected, actual
  end
  
  test "unlinked_traffic_light with explicit width and height" do
    expected = "" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='12'" +
          " height='40'/>"
    inc = { :colour => 'red' }
    width = 12
    height = 40
    actual = unlinked_traffic_light(inc,width,height)
    assert_equal expected, actual
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
