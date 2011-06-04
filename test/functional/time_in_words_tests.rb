require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/time_in_words_tests.rb

class TimeInWordsTests < ActionController::TestCase

  def time_split_unsplit_words(ydhms, total_seconds, words=nil)
    assert_equal total_seconds, time_unsplit(*ydhms)
    assert_equal ydhms, time_split(total_seconds)

    if words != nil
      assert_equal '>' + words, time_in_words(total_seconds)
    end    
  end

  def test_plural
    minute = 'min'
    assert_equal '0 mins', plural(0, minute)
    assert_equal '1 min', plural(1, minute)
    assert_equal '2 mins', plural(2, minute)    
  end
  
  def test_time_split_unsplit
    time_split_unsplit_words([0, 0, 0, 0, 0], 0, '0 secs')
    time_split_unsplit_words([0, 0, 0, 0, 1], 1, '1 sec')
    time_split_unsplit_words([0, 0, 0, 0, 2], 2, '2 secs')
    time_split_unsplit_words([0, 0, 0, 0, 3], 3, '3 secs')
    time_split_unsplit_words([0, 0, 0, 0,59], 59, '59 secs')
    
    time_split_unsplit_words([0, 0, 0, 1, 0], 60, '1 min')
    time_split_unsplit_words([0, 0, 0, 1, 1], 61, '1 min')
    time_split_unsplit_words([0, 0, 0, 1, 2], 62, '1 min')
    time_split_unsplit_words([0, 0, 0, 1, 3], 63, '1 min')
    time_split_unsplit_words([0, 0, 0, 1,59], 119, '1 min')
    time_split_unsplit_words([0, 0, 0, 2, 0], 120, '2 mins')
    
    time_split_unsplit_words([0, 0, 1, 0, 0], 3600, '1 hour')
    time_split_unsplit_words([0, 0, 1, 0, 1], 3601, '1 hour')
    time_split_unsplit_words([0, 0, 1, 0,59], 3659, '1 hour')
    time_split_unsplit_words([0, 0, 1, 1, 0], 3660, '1 hour')
    time_split_unsplit_words([0, 0, 1, 1, 1], 3661, '1 hour')
    time_split_unsplit_words([0, 0, 1, 1,59], 3719, '1 hour')
    time_split_unsplit_words([0, 0, 1, 2, 0], 3720, '1 hour')
    time_split_unsplit_words([0, 0, 2, 0, 0], 7200, '2 hours')
    time_split_unsplit_words([0, 0, 2, 0, 1], 7201, '2 hours')
 
    time_split_unsplit_words([0, 0,23,59,59], 86399, '23 hours')
    time_split_unsplit_words([0, 1, 0, 0, 0], 86400, '1 day')
    time_split_unsplit_words([0, 2, 0, 0, 1], 172801, '2 days')
    time_split_unsplit_words([1, 0, 0, 0, 0], 31536000, '1 year')
    time_split_unsplit_words([1, 0, 0, 0,15], 31536015, '1 year')
    time_split_unsplit_words([2, 0, 0, 0, 0], 63072000, '2 years')
    
  end
   
end

