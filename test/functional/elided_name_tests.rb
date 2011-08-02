require File.dirname(__FILE__) + '/../test_helper'
require 'elided_name_helper'

# > ruby test/functional/elides_name_tests.rb

class ElidedNameTests < ActionController::TestCase

  include ElidedNameHelper
  
  def test_when_name_length_is_less_than_max_no_elision_occurs
    name = "this is the name"
    assert_equal name, elided_name(name, name.length + 1)
  end

  def test_when_name_length_equals_max_no_elision_occurs
    name = "this is the name"
    assert_equal name, elided_name(name, name.length)
  end

  def test_when_name_length_is_greater_than_max_elision_does_occur
    name     = "this is the name"
    expected = "this is the nam..."
    assert_equal expected, elided_name(name, name.length - 1)
  end
  
end


