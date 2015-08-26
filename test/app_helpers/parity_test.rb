#!/bin/bash ../test_wrapper.sh

require_relative 'app_helpers_test_base'

class ParityTests < AppHelpersTestBase

  include ParityHelper

  test 'odd' do
    assert_equal 'odd', parity(1)
    assert_equal 'odd', parity(3)
    assert_equal 'odd', parity(5)
  end

  test 'even' do
    assert_equal 'even', parity(0)
    assert_equal 'even', parity(2)
    assert_equal 'even', parity(4)
  end

end
