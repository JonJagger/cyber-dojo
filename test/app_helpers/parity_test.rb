#!/bin/bash ../test_wrapper.sh

require_relative 'AppHelpersTestBase'

class ParityTests < AppHelpersTestBase

  include ParityHelper

  test '6AF185',
  'odd' do
    assert_equal 'odd', parity(1)
    assert_equal 'odd', parity(3)
    assert_equal 'odd', parity(5)
  end

  test 'D2D3BA',
  'even' do
    assert_equal 'even', parity(0)
    assert_equal 'even', parity(2)
    assert_equal 'even', parity(4)
  end

end
