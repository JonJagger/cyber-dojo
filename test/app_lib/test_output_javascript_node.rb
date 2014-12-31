#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputNodeTests < AppLibTestBase

  test "one fail is red" do
    output =
      [
        "AssertionError: \"FizzBuzz\" == \"sFizzBuzz\""
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "no fails and one pass is green" do
    output =
      [
        "All tests passed"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "syntax error of the first kind is amber" do
    output =
      [
        "SyntaxError: Unexpected string"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "syntax error of the second kind is amber" do
    output =
      [
        "ReferenceError: ss is not defined"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_node(output)
  end

end
