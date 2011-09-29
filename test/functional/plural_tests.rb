require File.dirname(__FILE__) + '/../test_helper'
require 'plural_helper'

# > ruby test/functional/plural_tests.rb

class PluralTests < ActionController::TestCase

  include PluralHelper
  
  def test_plural
    minute = 'min'
    assert_equal '0 mins', plural(0, minute)
    assert_equal '1 min', plural(1, minute)
    assert_equal '2 mins', plural(2, minute)    
  end
 
end

