require File.dirname(__FILE__) + '/../test_helper'
require 'parity_helper'

class ParityTests < ActionController::TestCase

  include ParityHelper
  
  test "odd" do
    assert_equal "odd", parity(1)
    assert_equal "odd", parity(3)
    assert_equal "odd", parity(5)
  end

  test "even" do
    assert_equal "even", parity(0)    
    assert_equal "even", parity(2)    
    assert_equal "even", parity(4)    
  end

end


