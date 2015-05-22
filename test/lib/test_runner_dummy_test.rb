#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class TestRunnerDummyTests < LibTestBase

  test 'runnable? is false' do
    assert !TestRunnerDummy.new.runnable?('kermit-the-frog')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'run tells you how to use HostTestRunner' do
    output = TestRunnerDummy.new.run(nil,nil,nil)
    assert output.include?('to use DockerTestRunner')
    assert output.include?('$ export CYBERDOJO_RUNNER_CLASS_NAME=DockerTestRunner')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) unaffected when output < 50K' do
    less = 'x'*(10*1024)
    output = TestRunnerDummy.new.limited(less,50*1024)
    assert_equal output, less
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) unaffected when output = 50K' do
    max_length = 50 * 1024
    longest = 'x'*max_length
    output = TestRunnerDummy.new.limited(longest,max_length)
    assert_equal output, longest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) truncated when output > 50K' do
    max_length = 50*1024
    too_long = 'x'*max_length + 'yyy'
    output = TestRunnerDummy.new.limited(too_long, max_length)
    expected = 'x'*max_length + "\n" +
               "output truncated by cyber-dojo server"
    assert_equal expected, output
  end

end
