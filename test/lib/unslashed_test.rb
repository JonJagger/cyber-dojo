#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class UnslashedTest < LibTestBase

  test '9C253E',
  'unslashed does not end in a slash' do
    assert_equal 's', unslashed('s')
    assert_equal 's', unslashed('s/')
  end

  private

  include Unslashed

end
