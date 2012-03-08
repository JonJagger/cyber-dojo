require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

class PopenReadTests < ActionController::TestCase

  test "popen_without_timeout_that_completes_returns_command_output" do
    assert_equal "#{expected}\n", Files::popen_read(command)
  end

  test "popen_with_timeout_that_completes_returns_command_output" do
    assert_equal "#{expected}\n", Files::popen_read(command, 2)
  end
  
  test "popen_with_timeout_that_times_out_returns_temination_output" do
    output = Files::popen_read('sleep 10000', 1)
    assert_not_nil output =~ /Terminated by the CyberDojo server after 1 seconds/, output 
  end

  def command
    "echo #{expected}"
  end
    
  def expected
    'Hello World'
  end
  
end


