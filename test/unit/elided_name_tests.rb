require File.dirname(__FILE__) + '/../test_helper'
require 'elided_name_helper'

# > ruby test/unit/elides_name_tests.rb

class ElidedNameTests < ActionController::TestCase

  include ElidedNameHelper
  
  test "when name length is less than max no elision occurs" do
    name = "this is the name"
    assert_equal name, elided_name(name, name.length + 1)
  end

  test "when name length equals max no elision occurs" do
    name = "this is the name"
    assert_equal name, elided_name(name, name.length)
  end

  test "when name length is greater than max elision does occur" do
    name     = "this is the name"
    expected = "this is the nam..."
    assert_equal expected, elided_name(name, name.length - 1)
  end
  
end


