require File.dirname(__FILE__) + '/../test_helper'

class IncrementsTests < ActionController::TestCase

  def test_passed_only_if_underlying_hash_outcome_passed
    assert Increment.new({:outcome => :passed}).passed?
    assert !Increment.new({:outcome => :failed}).passed?
    assert !Increment.new({:outcome => :error}).passed?
  end
  
  def test_time_equals_time_from_underlying_hash_time
    year = 2011
    month = 9
    day = 22
    hour = 3
    min = 4
    sec = 5
    t = [year,month,day,hour,min,sec]
    at = Increment.new({:time => t}).time
    assert_equal year, at.year
    assert_equal month, at.month
    assert_equal day, at.day
    assert_equal hour, at.hour
    assert_equal min, at.min
    assert_equal sec, at.sec
  end
  
  def test_less_than_10_minutes_ago_is_not_old
    at = 9.minutes.ago
    assert !Increment.new({:time => [at.year, at.month, at.day, at.hour, at.min, at.sec]}).old?
  end
  
  def test_more_than_10_minutes_ago_is_old
    at = 11.minutes.ago
    assert Increment.new({:time => [at.year, at.month, at.day, at.hour, at.min, at.sec]}).old?
  end  
  
  def test_increment_all_returns_an_array_and_each_element_is_an_object_not_a_hash
    at = 9.minutes.ago
    hash1 = {:time => [at.year, at.month, at.day, at.hour, at.min, at.sec]}
    at = 11.minutes.ago
    hash2 = {:time => [at.year, at.month, at.day, at.hour, at.min, at.sec]}
    hashes = [hash1, hash2]
    all = Increment.all(hashes)
    assert all.kind_of?(Array)
    assert all[0].kind_of?(Increment)
  end
  
end
