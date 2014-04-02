# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'

class OutputCatchTests < ActionController::TestCase

  include OutputParser

  test "RED" do
    output =
      [
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "run.tests is a Catch v1.0 b25 host application.",
        "Run with -? for options",
        "",
        "-------------------------------------------------------------------------------",
        "The answer to life the universe and everything",
        "-------------------------------------------------------------------------------",
        "untitled.tests.cpp:5",
        "...............................................................................",
        "",
        "untitled.tests.cpp:6: FAILED:",
        "  REQUIRE( hhg() == 6*9 )",
        "with expansion:",
        "  42 == 54",
        "",
        "===============================================================================",
        "1 test case - failed (1 assertion - failed)"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  test "AMBER" do
    output =
      [
        "untitled.cpp: In function 'int hhg()':",
        "untitled.cpp:5:12: error: unable to find numeric literal operator 'operator\"\" typo2'",
        "untitled.cpp:6:1: error: control reaches end of non-void function [-Werror=return-type]",
        "cc1plus: all warnings being treated as errors"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  test "GREEN" do
    output =
      [
        "All tests passed (1 assertion in 1 test case)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  def colour_of(output)
    OutputParser::parse_catch(output)
  end

end
