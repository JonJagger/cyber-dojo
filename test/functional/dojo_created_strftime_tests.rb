require File.dirname(__FILE__) + '/../test_helper'

class DojoCreateStrftimeTests < ActionController::TestCase
  
  def test_created_strftime_doesnt_always_end_in_09
    created = Time.mktime(*[2011,9,21,15,5,22])
    assert_equal "15:05", created.strftime("%H:%M")
  end
  
end
