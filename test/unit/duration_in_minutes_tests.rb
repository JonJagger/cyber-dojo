require File.dirname(__FILE__) + '/../test_helper'
require 'duration_helper'

class DurationInMinutesTests < ActionController::TestCase

  include DurationHelper

  def test_duration_in_minutes
    started = Time.mktime(2011,9,15,12,4,5)
    finished = Time.mktime(2011,9,15,12,6,7)
    assert_equal 2, duration_in_minutes(started, finished)
  end
      
end
