require File.dirname(__FILE__) + '/../test_helper'
require 'RawRunner'

class RawRunnerTests < ActionController::TestCase

  test "command executes within timeout and returns command output" do
    path = '.'
    command = 'echo "Hello"'
    max_duration = 2 # seconds
    assert_equal "Hello\n", RawRunner.new.run(path,command,max_duration)
  end

  test "command times-out returns termination output" do
    path = '.'
    command = 'sleep 10000'
    max_duration = 1 # second
    output = RawRunner.new.run(path,command,max_duration)
    assert_not_nil output =~ /Terminated by the cyber-dojo server after 1 seconds/, output
  end

end
