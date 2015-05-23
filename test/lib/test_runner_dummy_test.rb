#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class TestRunnerDummyTests < LibTestBase

  def setup
    super
    @runner = TestRunnerDummy.new
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'runnable? is false' do
    assert !@runner.runnable?('kermit-the-frog')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'run tells you how to use HostTestRunner' do
    output = @runner.run(nil,nil,nil)
    assert output.include?('to use DockerTestRunner')
    assert output.include?('$ export CYBERDOJO_RUNNER_CLASS_NAME=DockerTestRunner')
  end

end
