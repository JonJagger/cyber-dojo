require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionView::TestCase

  include TrafficLightHelper    
  
  test "tool tip" do
    light = { :number => 2, :time => [2012,5,1,23,20,45], :colour => :red }
    assert_equal "review hippo's<br>1 &harr; 2 diff<br>(2012 May 1, 23:20:45)",
      tool_tip('hippo', light)
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
      "show hippo's<br>current code" +
      "</div>" +
      "<img src='/images/avatars/hippo.jpg'" +
          " alt='hippo'" +
          " width='45'" +
          " height='45'/>" +
        "</div>"
    actual = no_diff_avatar_image(kata,avatar_name,light,max_lights)
    assert_equal expected, actual
  end
  
  # light[:colour] used to be light[:outcome]
    
  test "diff_traffic_light" do
    diff_traffic_light_func({:colour => 'red'})
    diff_traffic_light_func({:outcome => 'red'})
  end
    
  test "unlinked_traffic_light with defaults" do
    unlinked_traffic_light_with_defaults_func({ :colour => 'red' })
    unlinked_traffic_light_with_defaults_func({ :outcome => 'red' })    
  end
  
  test "unlinked_traffic_light with explicit width and height" do
    unlinked_traffic_light_with_explicit_width_and_height_func({ :colour => 'red' })
    unlinked_traffic_light_with_explicit_width_and_height_func({ :outcome => 'red' })
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def diff_traffic_light_func(light)
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar_name = 'hippo'
    light[:number] = 23
    light[:time] = [2012,5,1,23,20,45] 
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
      "review hippo's<br>22 &harr; 23 diff<br>(2012 May 1, 23:20:45)" +
      "</div>" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='20'" +
          " height='62'/>" +
      "</div>"
    actual = diff_traffic_light(kata,avatar_name,light,max_lights)
    assert_equal expected, actual    
  end
  
  def unlinked_traffic_light_with_defaults_func(light)
    expected = "" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='20'" +
          " height='62'/>"
    actual = unlinked_traffic_light(light)
    assert_equal expected, actual    
  end
  
  def unlinked_traffic_light_with_explicit_width_and_height_func(light)
    expected = "" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='12'" +
          " height='40'/>"
    width = 12
    height = 40
    actual = unlinked_traffic_light(light,width,height)
    assert_equal expected, actual
  end
  
end
