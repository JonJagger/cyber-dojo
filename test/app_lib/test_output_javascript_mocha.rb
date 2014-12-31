#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputMochaTests < AppLibTestBase

  test "no fails and no passes is green" do
    output =
      [
        "  0 passing (4ms)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "one fail and no passes is red" do
    output =
      [
        "     AssertionError: expected 54 to equal 42"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "no fails and one pass is green" do
    output =
      [
        "  1 passing (15ms)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "no fails and two passes is green" do
    output =
      [
        "  2 passing (17ms)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "syntax error of the first kind is amber" do
    output =
      [
        "SyntaxError: Unexpected token return"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "syntax error of the second kind is amber" do
    output =
      [
        "ReferenceError: smodule is not defined"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_mocha(output)
  end

end
