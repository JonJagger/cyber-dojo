require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'


class TrafficLightTests < ActionController::TestCase

  include TrafficLightHelper

  def test_dojo_duration_in_minutes
    started = Time.mktime(2011,9,15,12,4,5)
    finished = Time.mktime(2011,9,15,12,6,7)
    assert_equal 2, duration_in_minutes(started, finished)
  end
  
  def test_simple_bulb_html_creation
    assert_equal "<span class='failed bulb'></span>", bulb(:failed)
    assert_equal "<span class='error bulb'></span>", bulb(:error)
    assert_equal "<span class='passed bulb'></span>", bulb(:passed)
    assert_equal "<span class='off bulb'></span>", bulb(:off)
  end
  
  def test_simple_on_off_returns_argument_if_arguments_match
    assert_equal :same, on_off(:same, :same)
  end
  
  def test_simple_on_off_returns_off_if_arguments_dont_match
    assert_equal :off, on_off(:same, :not_same)
    assert_equal :off, on_off(:not_same, :same)
  end
  
  class FakeDojo
    def created; Time.now; end
    def name; "wibble"; end
  end
  
  def test_make_red_traffic_light
    expected = 
      "<span class='failed bulb'></span>" +
      "<span class='off bulb'></span>" +
      "<span class='off bulb'></span>"
    assert_equal expected, make_light({ :outcome => :failed }) 
  end
  
  def test_make_amber_traffic_light
    expected = 
      "<span class='off bulb'></span>" +
      "<span class='error bulb'></span>" +
      "<span class='off bulb'></span>"
    assert_equal expected, make_light({ :outcome => :error }) 
  end
  
  def test_make_green_traffic_light
    expected = 
      "<span class='off bulb'></span>" +
      "<span class='off bulb'></span>" +
      "<span class='passed bulb'></span>"
    assert_equal expected, make_light({ :outcome => :passed }) 
  end
  
  def test_tool_tip_when_minutes_not_1
    assert_equal 'Open a diff page (2)', tool_tip('gorilla', 2, 13)
  end
  
  def test_tool_tip_when_minutes_is_1
    assert_equal 'Open a diff page (2)', tool_tip('gorilla', 2, 1)
  end
  
end
