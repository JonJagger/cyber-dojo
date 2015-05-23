#!/usr/bin/env ../test_wrapper.sh lib

require_relative 'lib_test_base'

class TestRunnerTests < LibTestBase

  include TestRunner

  test 'limited(output) unaffected when output < max_output_length' do
    less = 'x' * (max_output_length - 1)
    output = limited(less)
    assert_equal output, less
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) unaffected when output == max_output_length' do
    longest = 'x' * max_output_length
    output = limited(longest)
    assert_equal output, longest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'limited(output) truncated when output > max_output_length' do
    longest = 'x' * max_output_length
    output = limited(longest + 'yyy')
    expected = longest + "\n" + 'output truncated by cyber-dojo server'
    assert_equal expected, output
  end

end
