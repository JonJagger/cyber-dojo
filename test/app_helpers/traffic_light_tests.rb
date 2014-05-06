require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionView::TestCase

  include TrafficLightHelper

  test "tool tip" do
    light = { 'number' => 2, 'time' => [2012,5,1,23,20,45], 'colour' => 'red' }
    assert_equal "review hippos 1 &harr; 2 diff", tool_tip('hippo', light)
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
    light = { 'number' => 23 }
    max_lights = 45
    expected = "" +
      "<div" +
      " class='diff-traffic-light'" +
      " title='review hippos current code'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='23'" +
      " data-now-tag='23'" +
      " data-max-tag='45'>" +
      "<img src='/images/avatars/hippo.jpg'" +
          " alt='hippo'" +
          " width='45'" +
          " height='45'/>" +
        "</div>"
    actual = no_diff_avatar_image(kata,avatar_name,light,max_lights)
    assert_equal expected, actual
  end

  test "diff_traffic_light" do
    # light[:colour] used to be light[:outcome]
    diff_traffic_light_func({'colour' => 'red'})
    diff_traffic_light_func({'outcome' => 'red'})
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def diff_traffic_light_func(light)
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar_name = 'hippo'
    light['number'] = 23
    light['time'] = [2012,5,1,23,20,45]
    max_lights = 45
    expected = "" +
      "<div" +
      " class='diff-traffic-light'" +
      " title='review hippos 22 &harr; 23 diff'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='22'" +
      " data-now-tag='23'" +
      " data-max-tag='45'>" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='17'" +
          " height='54'/>" +
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
