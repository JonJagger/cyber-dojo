require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

class PopenReadTests < ActionController::TestCase

  test "popen without timeout that completes returns command output" do
    assert_equal "#{expected}\n", Files::popen_read(command)
  end

  test "popen with timeout that completes returns command output" do
    assert_equal "#{expected}\n", Files::popen_read(command, 2)
  end
  
  test "popen with timeout that times out returns temination output" do
    output = Files::popen_read('sleep 10000', 1)
    assert_not_nil output =~ /Terminated by the cyber-dojo server after 1 seconds/, output 
  end

  def command
    "echo #{expected}"
  end
    
  def expected
    'Hello World'
  end
  
end


