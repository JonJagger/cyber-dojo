require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/popen_read_tests.rb

class PopenReadTests < Test::Unit::TestCase

  include Files
  
  def test_popen_read_without_timeout
    assert_equal "Linux\n", popen_read('uname')
  end

  def test_popen_read_with_timeout
    assert_equal "Linux\n", popen_read('uname', 2)
  end
  
  def test_popen_read_when_timeout_times_out
    output = popen_read('sleep 10000', 1)
    assert_not_nil output =~ /Terminated by the CyberDojo server after 1 seconds/, output 
  end
end


