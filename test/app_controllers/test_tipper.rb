#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class TipperControllerTest < AppControllerTestBase

  test '25E3D4',
  'traffic_light_tip' do
    @id = create_kata
    1.times { start; 2.times { run_tests } }
    get 'tipper/traffic_light_tip',
      format: :js,
      id: @id,
      avatar: @avatar.name,
      was_tag: 0,
      now_tag: 1
    assert_response :success
  end

end
