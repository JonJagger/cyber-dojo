#!/bin/bash ../test_wrapper.sh

require_relative 'LibTestBase'
require 'tempfile'

class SandboxStub
  def path
    '.'
  end
end

class HostRunnerTests < LibTestBase

  test 'command executes within timeout and returns command output' do
    sandbox = SandboxStub.new
    command = 'echo "Hello"'
    max_duration = 2 # seconds
    assert_equal "Hello\n", host_runner.run(sandbox, command, max_duration)
  end

  test 'when command times-out output includes unable-to-complete message' do
    sandbox = SandboxStub.new
    command = 'sleep 10000' # 10 seconds
    max_duration = 1 # second
    output = nil
    capture_all do
      output = host_runner.run(sandbox, command, max_duration)
    end
    assert_match /Unable to complete the tests in 1 seconds/, output
    assert_match /Is there an accidental infinite loop?/, output
    assert_match /Is the server very busy?/, output
    assert_match /Please try again/, output
  end

  def host_runner
    HostRunner.new
  end
  
  def capture_all
    backup_stderr = STDERR.dup
    backup_stdout = STDOUT.dup
    begin
      stderr = Tempfile.open("captured_stderr")
      stdout = Tempfile.open("captured_stdout")
      STDERR.reopen(stderr)
      STDOUT.reopen(stdout)
      yield
      stdout.rewind
      stderr.rewind
      stdout.read + stderr.read
    ensure
      STDERR.reopen backup_stderr
      STDOUT.reopen backup_stdout
    end
  end

end
