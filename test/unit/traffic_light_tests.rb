require File.dirname(__FILE__) + '/../test_helper'
require 'traffic_light_helper'

class TrafficLightTests < ActionController::TestCase

  include TrafficLightHelper

  def test_unlinked_traffic_light_red
    expected = 
      "<img src='/images/traffic-light-red.png' border='0' width='23' height='69'/>"
    assert_equal expected, unlinked_traffic_light({ :outcome => :failed }) 
  end
  
  def test_unlinked_traffic_light_amber
    expected = 
      "<img src='/images/traffic-light-amber.png' border='0' width='23' height='69'/>"
    assert_equal expected, unlinked_traffic_light({ :outcome => :error }) 
  end
  
  def test_unlinked_traffic_light_green
    expected = 
      "<img src='/images/traffic-light-green.png' border='0' width='23' height='69'/>"
    assert_equal expected, unlinked_traffic_light({ :outcome => :passed }) 
  end
  
  def test_tool_tip
    inc_number = 2
    assert_equal 'Open a diff page (2)', tool_tip(inc_number)
  end
  
end
