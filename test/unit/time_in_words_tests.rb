require File.dirname(__FILE__) + '/../test_helper'
require 'time_in_words_helper'

# > ruby test/functional/time_in_words_tests.rb

class TimeInWordsTests < ActionController::TestCase

  include TimeInWordsHelper
  
  def time_split_unsplit_words(ydhms, total_seconds, words=nil)
    assert_equal total_seconds, time_unsplit(*ydhms)
    assert_equal ydhms, time_split(total_seconds)

    if words != nil
      assert_equal words, time_in_words(total_seconds)
    end    
  end

  def test_plural
    minute = 'minute'
    assert_equal '0 minutes', plural(0, minute)
    assert_equal '1 minute', plural(1, minute)
    assert_equal '2 minutes', plural(2, minute)    
  end
  
  def test_time_split_unsplit
    time_split_unsplit_words([0, 0, 0, 0, 0], 0,  '0 seconds')
    time_split_unsplit_words([0, 0, 0, 0, 1], 1,  '1 second')
    time_split_unsplit_words([0, 0, 0, 0, 2], 2,  '2 seconds')
    time_split_unsplit_words([0, 0, 0, 0, 3], 3,  '3 seconds')
    time_split_unsplit_words([0, 0, 0, 0,59],59, '59 seconds')
    
    time_split_unsplit_words([0, 0, 0, 1, 0],  60, '1 minute')
    time_split_unsplit_words([0, 0, 0, 1, 1],  61, '1 minute 1 second')
    time_split_unsplit_words([0, 0, 0, 1, 2],  62, '1 minute 2 seconds')
    time_split_unsplit_words([0, 0, 0, 1, 3],  63, '1 minute 3 seconds')
    time_split_unsplit_words([0, 0, 0, 1,59], 119, '1 minute 59 seconds')
    time_split_unsplit_words([0, 0, 0, 2, 0], 120, '2 minutes')
    
    time_split_unsplit_words([0, 0, 1, 0, 0],  3600, 'about 1 hour')
    time_split_unsplit_words([0, 0, 1, 0, 1],  3601, 'about 1 hour')
    time_split_unsplit_words([0, 0, 1, 0,59],  3659, 'about 1 hour')
    time_split_unsplit_words([0, 0, 1, 1, 0],  3660, 'about 1 hour 1 minute')
    time_split_unsplit_words([0, 0, 1, 1, 1],  3661, 'about 1 hour 1 minute')
    time_split_unsplit_words([0, 0, 1, 1,59],  3719, 'about 1 hour 1 minute')
    time_split_unsplit_words([0, 0, 1, 2, 0],  3720, 'about 1 hour 2 minutes')
    time_split_unsplit_words([0, 0, 2, 0, 0],  7200, 'about 2 hours')
    time_split_unsplit_words([0, 0, 2, 0, 1],  7201, 'about 2 hours')
    time_split_unsplit_words([0, 0, 4,13, 1], 15181, 'about 4 hours 13 minutes')
    time_split_unsplit_words([0, 0,23,59,59], 86399, 'about 23 hours 59 minutes')
    
    time_split_unsplit_words([0, 1, 0, 0, 0],  86400, 'about 1 day')
    time_split_unsplit_words([0, 1, 0, 0, 1],  86401, 'about 1 day')
    time_split_unsplit_words([0, 1, 1, 0, 0],  90000, 'about 1 day 1 hour')
    time_split_unsplit_words([0, 1, 3, 0, 0],  97200, 'about 1 day 3 hours')
    time_split_unsplit_words([0, 2, 0, 0, 1], 172801, 'about 2 days')
    time_split_unsplit_words([0, 2, 3, 0, 1], 183601, 'about 2 days 3 hours')
    time_split_unsplit_words([0, 2,11, 0, 1], 212401, 'about 2 days 11 hours')
    
    time_split_unsplit_words([1, 0, 0, 0, 0], 31536000, 'about 1 year')
    time_split_unsplit_words([1, 0, 0, 0,15], 31536015, 'about 1 year')
    time_split_unsplit_words([1, 0, 0, 3,15], 31536195, 'about 1 year')
    time_split_unsplit_words([1, 0, 2, 0,15], 31543215, 'about 1 year')
    time_split_unsplit_words([1, 1, 0, 0,15], 31622415, 'about 1 year 1 day')
    time_split_unsplit_words([1,43, 0, 0,15], 35251215, 'about 1 year 43 days')
    time_split_unsplit_words([2, 0, 0, 0, 0], 63072000, 'about 2 years')    
    time_split_unsplit_words([2, 0, 0, 0, 2], 63072002, 'about 2 years')    
    time_split_unsplit_words([2,56, 0, 0, 2], 67910402, 'about 2 years 56 days')    
  end
   
end

