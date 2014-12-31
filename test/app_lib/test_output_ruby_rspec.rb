#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputRubyRSpecTests < AppLibTestBase

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
