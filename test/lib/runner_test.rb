#!/bin/bash ../test_wrapper.sh

require_relative 'LibTestBase'

class RunnerTests < LibTestBase

  include Runner

  test 'EEBD0D',
  'limited(output) unaffected when output < max_output_length' do
    less = 'x' * (max_output_length - 1)
    output = limited(less)
    assert_equal output, less
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'F389D9',
  'limited(output) unaffected when output == max_output_length' do
    longest = 'x' * max_output_length
    output = limited(longest)
    assert_equal output, longest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'DB527A',
  'limited(output) truncated when output > max_output_length' do
    longest = 'x' * max_output_length
    output = limited(longest + 'yyy')
    expected = longest + "\n" + 'output truncated by cyber-dojo server'
    assert_equal expected, output
  end

end
