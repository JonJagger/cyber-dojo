require 'test_helper'
require 'ellided_name_helper'

# > cd cyberdojo/test
# > ruby functional/ellides_name_tests.rb

class EllidedNameTests < ActionController::TestCase

  include EllidedNameHelper
  
  def test_when_name_length_is_less_than_max
    name = "this is the name"
    assert_equal name, ellided_name(name, name.length + 1)
  end

  def test_when_name_length_equals_max
    name = "this is the name"
    assert_equal name, ellided_name(name, name.length)
  end

  def test_when_name_length_is_greater_than_max
    name     = "this is the name"
    expected = "this is the nam..."
    assert_equal expected, ellided_name(name, name.length - 1)
  end
  
end


