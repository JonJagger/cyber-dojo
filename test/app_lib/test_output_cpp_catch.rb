#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputCatchTests < AppLibTestBase

  test 'one failing test is red' do
    output =
      [
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "run.tests is a Catch v1.0 b39 host application.",
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

  # - - - - - - - - - - - - - - -

  test 'one passing test is green' do
    output =
      [
        "All tests passed (1 assertion in 1 test case)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'two failing tests is red' do
    output =
      [
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "run.tests is a Catch v1.0 b39 host application.",
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
        "-------------------------------------------------------------------------------",
        "The answer to life the universe and everything2",
        "-------------------------------------------------------------------------------",
        "untitled.tests.cpp:9",
        "...............................................................................",
        "",
        "untitled.tests.cpp:10: FAILED:",
        "  REQUIRE( hhg() == 6*9 )",
        "with expansion:",
        "  42 == 54",
        "",
        "===============================================================================",
        "2 test cases - both failed (2 assertions - both failed)"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'three failing tests is red' do
    output =
      [
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "run.tests is a Catch v1.0 b39 host application.",
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
        "-------------------------------------------------------------------------------",
        "The answer to life the universe and everything2",
        "-------------------------------------------------------------------------------",
        "untitled.tests.cpp:9",
        "...............................................................................",
        "",
        "untitled.tests.cpp:10: FAILED:",
        "  REQUIRE( hhg() == 6*9 )",
        "with expansion:",
        "  42 == 54",
        "",
        "-------------------------------------------------------------------------------",
        "The answer to life the universe and everything3",
        "-------------------------------------------------------------------------------",
        "untitled.tests.cpp:13",
        "...............................................................................",
        "",
        "untitled.tests.cpp:14: FAILED:",
        "  REQUIRE( hhg() == 6*9 )",
        "with expansion:",
        "  42 == 54",
        "",
        "===============================================================================",
        "3 test cases - all failed (3 assertions - all failed)"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'two passing tests is green' do
    output =
      [
        "All tests passed (2 assertions in 2 test cases)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'three passing tests is green' do
    output =
      [
        "All tests passed (3 assertions in 3 test cases)"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'one failing test and one passing test is red' do
    output =
      [
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "run.tests is a Catch v1.0 b39 host application.",
        "Run with -? for options",
        "",
        "-------------------------------------------------------------------------------",
        "The answer to life the universe and everything2",
        "-------------------------------------------------------------------------------",
        "untitled.tests.cpp:9",
        "...............................................................................",
        "",
        "untitled.tests.cpp:10: FAILED:",
        "  REQUIRE( hhg() == 6*9 )",
        "with expansion:",
        "  42 == 54",
        "",
        "===============================================================================",
        "2 test cases - 1 failed (2 assertions - 1 failed)"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'syntax error is amber' do
    output =
      [
        "untitled.cpp: In function 'int hhg()':",
        "untitled.cpp:5:12: error: unable to find numeric literal operator 'operator\"\" typo2'",
        "untitled.cpp:6:1: error: control reaches end of non-void function [-Werror=return-type]",
        "cc1plus: all warnings being treated as errors"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_catch(output)
  end

end
