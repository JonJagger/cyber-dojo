require File.dirname(__FILE__) + '/../test_helper'
require 'age_helper'

class AgeTests < ActionView::TestCase

  include AgeHelper

  def assert_age_equal(fmt,dd,hh,mm,ss)
    assert ss >= 0 && ss < 60, "ss (0,60]"
    assert mm >= 0 && mm < 60, "mm (0,60]"
    assert hh >= 0 && hh < 24, "hh (0,24]"
    assert dd >= 0, "dd >= 0"
    seconds = 24*60*60*dd + 60*60*hh + 60*mm + ss
    assert_equal [dd, hh, mm, ss], age_from_seconds(seconds)
    assert_equal fmt, formatted_age_from_seconds(seconds)
  end
  
  test "dropping of leading fields if they are zero and zero padding of those that arent" do
    assert_age_equal(":00", 0, 0, 0, 0)    
    assert_age_equal(":07", 0, 0, 0, 7)    
    assert_age_equal(":34", 0, 0, 0,34)                 
    assert_age_equal(":59", 0, 0, 0,59)
    
    assert_age_equal("01:00", 0, 0, 1, 0)    
    assert_age_equal("01:01", 0, 0, 1, 1)    
    assert_age_equal("01:59", 0, 0, 1,59)    
    assert_age_equal("02:00", 0, 0, 2, 0)    
    assert_age_equal("59:59", 0, 0,59,59)

    assert_age_equal("01:00:00", 0, 1, 0, 0)    
    assert_age_equal("01:00:01", 0, 1, 0, 1)
    assert_age_equal("01:00:59", 0, 1, 0,59)
    assert_age_equal("01:01:00", 0, 1, 1, 0)
    assert_age_equal("01:01:01", 0, 1, 1, 1)
    assert_age_equal("01:02:03", 0, 1, 2, 3)    
    assert_age_equal("01:15:29", 0, 1,15,29)
    assert_age_equal("23:09:02", 0,23, 9, 2)
    assert_age_equal("23:59:59", 0,23,59,59)
    
    assert_age_equal("1:00:00:00", 1, 0, 0, 0)
    assert_age_equal("1:02:03:04", 1, 2, 3, 4)
    assert_age_equal("1:21:33:45", 1,21,33,45)
    assert_age_equal("1:23:59:59", 1,23,59,59)
    assert_age_equal("2:00:00:00", 2, 0, 0, 0)
  end
  
end

