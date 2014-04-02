# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'

class OutputGoTests < ActionController::TestCase

  include OutputParser

  test "build failed is amber" do
    assert_equal :amber, colour_of("[build failed]")
  end

  test "ran but failed is green" do
    assert_equal :red, colour_of("FAIL")
  end

  test "ran and passed is red" do
    assert_equal :green, colour_of("PASS")
  end

  test "anything else is amber" do
    assert_equal :amber, colour_of("anything else")
  end

  def colour_of(output)
    OutputParser::parse_go_testing(output)
  end

end
