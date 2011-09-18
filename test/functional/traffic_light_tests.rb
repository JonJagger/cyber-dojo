require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'


class TrafficLightTests < ActionController::TestCase

  include TrafficLightHelper

  def test_dojo_duration_in_minutes
    started = Time.mktime(2011,9,15,12,4,5)
    finished = Time.mktime(2011,9,15,12,6,7)
    assert_equal 2, duration_in_minutes(started, finished)
  end
  
end
