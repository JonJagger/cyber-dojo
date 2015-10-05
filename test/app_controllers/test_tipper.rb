#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class TipperControllerTest < AppControllerTestBase

  test '25E3D4',
  'traffic_light_tip' do
    @id = create_kata
    1.times { enter; 2.times { run_tests } }
    get 'tipper/traffic_light_tip',
      format: :js,
      id: @id,
      avatar: @avatar.name,
      was_tag: 0,
      now_tag: 1
    assert_response :success
  end

  # - - - - - - - - - - - - - - - -

  test 'BB7C60',
  'traffic_light_count_tip' do
    @id = create_kata
    1.times { enter; }
    get 'tipper/traffic_light_count_tip',
      format: :js,
      avatar: @avatar.name,
      bulb_count: 0,
      current_colour: 'red',
      red_count: 3,
      amber_count: 5,
      green_count: 6,
      timed_out_count: 0
    assert_response :success
  end

end
