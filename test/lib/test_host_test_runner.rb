#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class HostTestRunnerTests < CyberDojoTestBase

  class StubSandbox
    def path
      '.'
    end
  end

  test 'command executes within timeout and returns command output' do
    sandbox = StubSandbox.new
    command = 'echo "Hello"'
    max_duration = 2 # seconds
    assert_equal "Hello\n", HostTestRunner.new.run(sandbox, command, max_duration)
  end

  test 'when command times-out output includes unable-to-complete message' do
    sandbox = StubSandbox.new
    command = 'sleep 10000'
    max_duration = 1 # second
    output = HostTestRunner.new.run(sandbox, command, max_duration)
    assert_match /Unable to complete the tests in 1 seconds/, output
    assert_match /Is there an accidental infinite loop?/, output
    assert_match /Is the server very busy?/, output
    assert_match /Please try again/, output
  end

end
