require File.dirname(__FILE__) + '/../test_helper'
require 'TimeBoxedTask'

class TimeBoxedTaskTests < ActionController::TestCase

  test "command executes within timeout that completes returns command output" do
    assert_equal "#{expected}\n", TimeBoxedTask.new.execute(command, 2)
  end
  
  test "command times out returns temination output" do
    output = TimeBoxedTask.new.execute('sleep 10000', 1)
    assert_not_nil output =~ /Terminated by the cyber-dojo server after 1 seconds/, output 
  end

  def command
    "echo #{expected}"
  end
    
  def expected
    'Hello World'
  end
  
end


