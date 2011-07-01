require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/popen_read_tests.rb

class PopenReadTests < Test::Unit::TestCase

  def xtest_popen_read_without_timeout
    assert_equal "Linux\n", popen_read('uname')
  end

  def xtest_popen_read_with_timeout
    assert_equal "Linux\n", popen_read('uname', 1)
  end
  
  def test_popen_read_when_timeout_times_out
    assert_equal "Terminated\n", popen_read('sleep 10000', 1)
  end
end


