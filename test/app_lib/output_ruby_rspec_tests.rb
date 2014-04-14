# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'

class OutputRubyRSpecTests < ActionController::TestCase

  include OutputParser

  test "F is red" do
    output = "F"
    assert_equal :red, colour_of(output)
  end

  test ".F is red" do
    output = ".F"
    assert_equal :red, colour_of(output)
  end

  test "..F is red" do
    output = "..F"
    assert_equal :red, colour_of(output)
  end

  test "..F..is red" do
    output = "..F.."
    assert_equal :red, colour_of(output)
  end

  test "all .$ is green" do
    output = "."
    assert_equal :green, colour_of(output)
  end

  test "all ..$ is green" do
    output = ".."
    assert_equal :green, colour_of(output)
  end

  test "all .......$ is green" do
    output = "......."
    assert_equal :green, colour_of(output)
  end

  test "no lines only . and F is amber" do
    output = ".X.F"
    assert_equal :amber, colour_of(output)
  end

  def colour_of(output)
    OutputParser::parse_ruby_rspec(output)
  end

end
