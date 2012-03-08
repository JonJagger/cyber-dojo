require File.dirname(__FILE__) + '/../test_helper'
require 'time_in_words_helper'

class TimeInWordsTests < ActionController::TestCase

  include TimeInWordsHelper
  
  test "time split unsplit" do
    time_split_unsplit_words([0, 0, 0, 0, 0], 0,  '0 seconds')
    time_split_unsplit_words([0, 0, 0, 0, 1], 1,  '1 second')
    time_split_unsplit_words([0, 0, 0, 0, 2], 2,  '2 seconds')
    time_split_unsplit_words([0, 0, 0, 0, 3], 3,  '3 seconds')
    time_split_unsplit_words([0, 0, 0, 0,59],59, '59 seconds')
    
    time_split_unsplit_words([0, 0, 0, 1, 0],  60, '1 minute')
    time_split_unsplit_words([0, 0, 0, 1, 1],  61, '1 minute')
    time_split_unsplit_words([0, 0, 0, 1, 2],  62, '1 minute')
    time_split_unsplit_words([0, 0, 0, 1, 3],  63, '1 minute')
    time_split_unsplit_words([0, 0, 0, 1,59], 119, '1 minute')
    time_split_unsplit_words([0, 0, 0, 2, 0], 120, '2 minutes')
    
    time_split_unsplit_words([0, 0, 1, 0, 0],  3600, '1 hour')
    time_split_unsplit_words([0, 0, 1, 0, 1],  3601, '1 hour')
    time_split_unsplit_words([0, 0, 1, 0,59],  3659, '1 hour')
    time_split_unsplit_words([0, 0, 1, 1, 0],  3660, '1 hour')
    time_split_unsplit_words([0, 0, 1, 1, 1],  3661, '1 hour')
    time_split_unsplit_words([0, 0, 1, 1,59],  3719, '1 hour')
    time_split_unsplit_words([0, 0, 1, 2, 0],  3720, '1 hour')
    time_split_unsplit_words([0, 0, 2, 0, 0],  7200, '2 hours')
    time_split_unsplit_words([0, 0, 2, 0, 1],  7201, '2 hours')
    time_split_unsplit_words([0, 0, 4,13, 1], 15181, '4 hours')
    time_split_unsplit_words([0, 0,23,59,59], 86399, '23 hours')
    
    time_split_unsplit_words([0, 1, 0, 0, 0],  86400, '1 day')
    time_split_unsplit_words([0, 1, 0, 0, 1],  86401, '1 day')
    time_split_unsplit_words([0, 1, 1, 0, 0],  90000, '1 day')
    time_split_unsplit_words([0, 1, 3, 0, 0],  97200, '1 day')
    time_split_unsplit_words([0, 2, 0, 0, 1], 172801, '2 days')
    time_split_unsplit_words([0, 2, 3, 0, 1], 183601, '2 days')
    time_split_unsplit_words([0, 2,11, 0, 1], 212401, '2 days')
    
    time_split_unsplit_words([1, 0, 0, 0, 0], 31536000, '1 year')
    time_split_unsplit_words([1, 0, 0, 0,15], 31536015, '1 year')
    time_split_unsplit_words([1, 0, 0, 3,15], 31536195, '1 year')
    time_split_unsplit_words([1, 0, 2, 0,15], 31543215, '1 year')
    time_split_unsplit_words([1, 1, 0, 0,15], 31622415, '1 year')
    time_split_unsplit_words([1,43, 0, 0,15], 35251215, '1 year')
    time_split_unsplit_words([2, 0, 0, 0, 0], 63072000, '2 years')    
    time_split_unsplit_words([2, 0, 0, 0, 2], 63072002, '2 years')    
    time_split_unsplit_words([2,56, 0, 0, 2], 67910402, '2 years')    
  end
   
  def time_split_unsplit_words(ydhms, total_seconds, words=nil)
    assert_equal total_seconds, time_unsplit(*ydhms)
    assert_equal ydhms, time_split(total_seconds)

    if words != nil
      assert_equal words, time_in_words(total_seconds)
    end    
  end
   
end

