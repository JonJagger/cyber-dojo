#!/usr/bin/env ruby

require_relative 'app_helpers_test_base'

class TrafficLightTests < AppHelpersTestBase

  include TrafficLightHelper

  test 'traffic_light_image' do
    expected = "<img src='/images/traffic_light_red.png'" +
               " alt='red traffic-light'" +
               " width='12'" +
               " height='38'/>"
    color = 'red'
    width = '12'
    height = '38'
    actual = traffic_light_image(color,width,height)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - -

  test 'diff_avatar_image' do
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar = Avatar.new(kata,'hippo')
    def avatar.lights; [1]*27; end
    expected = "" +
      "<div" +
      " class='diff-traffic-light avatar-image'" +
      " data-tip='Click to review hippo&#39;s current code'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='-1'" +
      " data-now-tag='-1'>" +
      "<img src='/images/avatars/hippo.jpg'" +
          " alt='hippo'" +
          " width='45'" +
          " height='45'/>" +
        "</div>"
    actual = diff_avatar_image(avatar)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - -

  test 'diff_traffic_light' do
    # light[:colour] used to be light[:outcome]
    diff_traffic_light_func({'colour' => 'red'})
    diff_traffic_light_func({'outcome' => 'red'})
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def diff_traffic_light_func(light)
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar = Avatar.new(kata,'hippo')
    def avatar.lights; [1]*7; end
    light = Light.new(avatar, {
      'number' => 3,
      'colour' => 'red'
    })
    expected = "" +
      "<div" +
      " class='diff-traffic-light'" +
      " data-tip='ajax:traffic_light'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='2'" +
      " data-now-tag='3'>" +
      "<img src='/images/traffic_light_red.png'" +
          " alt='red traffic-light'" +
          " width='17'" +
          " height='54'/>" +
      "</div>"
    actual = diff_traffic_light(light)
    assert_equal expected, actual
  end

end
