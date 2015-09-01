#!/bin/bash ../test_wrapper.sh

require_relative 'app_helpers_test_base'

class TrafficLightTests < AppHelpersTestBase

  include TrafficLightHelper

  test 'traffic_light_count' do
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar = Avatar.new(kata,'hippo')
      def avatar.red_light
        stub = Object.new
        def stub.colour; :red; end;
        stub
      end
      def avatar.green_light
        stub = Object.new
        def stub.colour; :green; end;
        stub
      end
      def avatar.amber_light
        stub = Object.new
        def stub.colour; :amber; end;
        stub
      end
      def avatar.lights;
        [red_light, red_light,green_light,amber_light,amber_light]
      end
    expected =
      "<div class='traffic-light-count amber'" +
          " data-tip='ajax:traffic_light_count'" +
          " data-id='ABCD1234'" +
          " data-avatar-name='hippo'" +
          " data-current-colour='amber'" +
          " data-red-count='2'" +
          " data-amber-count='2'" +
          " data-green-count='1'" +
          " data-timed-out-count='0'>" +
        "5<" +
      "/div>"
    actual = traffic_light_count(avatar)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - -

  test 'traffic_light_image' do
    color = 'red'
    expected = "<img src='/images/bulb_#{color}.png'" +
               " alt='red traffic-light'/>"
    actual = traffic_light_image(color)
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
          " alt='hippo'/>" +
        "</div>"
    actual = diff_avatar_image(avatar)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - -

  test 'diff_traffic_light' do
    diff_traffic_light_func({'colour' => 'red'})
    diff_traffic_light_func({'outcome' => 'red'})
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def diff_traffic_light_func(light)
    kata = Object.new
    def kata.id; 'ABCD1234'; end
    avatar = Avatar.new(kata,'hippo')
    def avatar.lights; [1]*7; end
    tag = 3
    color = 'red'
    light = Tag.new(avatar, {
      'number' => tag,
      'colour' => color
    })
    expected = "" +
      "<div" +
      " class='diff-traffic-light'" +
      " data-tip='ajax:traffic_light'" +
      " data-id='ABCD1234'" +
      " data-avatar-name='hippo'" +
      " data-was-tag='#{tag-1}'" +
      " data-now-tag='#{tag}'>" +
      "<img src='/images/bulb_#{color}.png'" +
          " alt='#{color} traffic-light'/>" +
      "</div>"
    actual = diff_traffic_light(light)
    assert_equal expected, actual
  end

end
