#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputHaskellTests < AppLibTestBase

  test "one fail is red" do
    output =
      [
        "Cases: 1  Tried: 0  Errors: 0  Failures: 0",
        "",
        "### Failure in: 0",
        "Testing answer",
        "expected: 54",
         "but got: 42",
        "Cases: 1  Tried: 1  Errors: 0  Failures: 1",
        "Counts {cases = 1, tried = 1, errors = 0, failures = 1}"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "one pass is green" do
    output =
      [
        "Cases: 1  Tried: 0  Errors: 0  Failures: 0",
        "",
        "Cases: 1  Tried: 1  Errors: 0  Failures: 0",
        "Counts {cases = 1, tried = 1, errors = 0, failures = 0}"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "one pass one fail is red" do
    output =
      [
        "Cases: 2  Tried: 0  Errors: 0  Failures: 0",
        "Cases: 2  Tried: 1  Errors: 0  Failures: 0",
        "",
        "### Failure in: 1",
        "Testing answer",
        "expected: 54",
        " but got: 42",
        "Cases: 2  Tried: 2  Errors: 0  Failures: 1",
        "Counts {cases = 2, tried = 2, errors = 0, failures = 1}"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "syntax error is amber" do
    output =
      [
        "test_Untitled.hs:8:31: Not in scope: `answer2_test'"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test "no tests is amber" do
    # Got this by raising an error exception
    # answer :: Int
    # answer = do
    #    error "Ooops"
    output =
      [
        "Cases: 1  Tried: 1  Errors: 1  Failures: 0",
        "Counts {cases = 1, tried = 1, errors = 1, failures = 0}"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_hunit(output)
  end

end
