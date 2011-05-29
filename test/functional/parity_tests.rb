require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/parity_tests.rb

class ParityTests < ActionController::TestCase

  def test_odd
    assert_equal "odd", parity(1)
    assert_equal "odd", parity(3)
    assert_equal "odd", parity(5)
  end

  def test_even
    assert_equal "even", parity(0)    
    assert_equal "even", parity(2)    
    assert_equal "even", parity(4)    
  end

end


