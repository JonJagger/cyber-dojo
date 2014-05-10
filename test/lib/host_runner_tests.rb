require File.dirname(__FILE__) + '/../test_helper'
require 'HostRunner'

class HostRunnerTests < ActionController::TestCase

  class StubPaas
    def path(sandbox)
      '.'
    end
  end

  test "command executes within timeout and returns command output" do
    paas = StubPaas.new
    sandbox = Object.new
    command = 'echo "Hello"'
    max_duration = 2 # seconds
    assert_equal "Hello\n", HostRunner.new.run(paas, sandbox, command,max_duration)
  end

  test "when command times-out output includes termination output" do
    paas = StubPaas.new
    sandbox = Object.new
    command = 'sleep 10000'
    max_duration = 1 # second
    output = HostRunner.new.run(paas, sandbox, command, max_duration)
    assert_not_nil output =~ /Terminated by the cyber-dojo server after 1 seconds/, output
  end

end
