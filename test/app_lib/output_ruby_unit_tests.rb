# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'

class OutputRubyUnitTests < ActionController::TestCase

  include OutputParser

  test "was a red ruby case" do
    output =
      [
        "Loaded suite test_get_digits",
        "Started",
        "F...........F.F..",
        "Finished in 0.01447 seconds.",
        '<"     _   _ \n  | | | |_|\n  | |_|   |">.',
        '<" _     \n| |   |\n|_|   |">.',
        '  3) Failure:',
        '<" _   _ \n  |  _|\n  | |_ ">.',
        '17 tests, 17 assertions, 3 failures, 0 errors',
        '',
        '  2) Failure:',
        'test_ten(TestGetDigits) [test_get_digits.rb:81]:',
        '<"     _ \n  | | |\n  | |_|"> expected but was',
        '<" _     \n| |   |\n|_|   |">.',
        '',
        '  3) Failure:',
        'test_twenty_seven(TestGetDigits) [test_get_digits.rb:95]:',
        '<" _   _ \n _|   |\n|_    |"> expected but was',
        '<" _   _ \n  |  _|\n  | |_ ">.',
        '',
        '17 tests, 17 assertions, 3 failures, 0 errors',
        '[[" _ ", " _ "], ["  |", " _|"], ["  |", "|_ "]]'
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  test "one failing test no passing tests is red" do
    output =
      [
        "Run options: ",
        "",
        "# Running tests:",
        "",
        "F",
        "",
        "Finished tests in 0.013886s, 72.0150 tests/s, 72.0150 assertions/s.",
        "",
        "  1) Failure:",
        "test_simple(TestUntitled) [test_untitled.rb:7]:",
        "<54> expected but was",
        "<42>.",
        "",
        "1 tests, 1 assertions, 1 failures, 0 errors, 0 skips"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  test "one passing test no failing test is green" do
    output =
      [
        "Run options: ",
        "",
        "# Running tests:",
        "",
        ".",
        "",
        "Finished tests in 0.016653s, 60.0492 tests/s, 60.0492 assertions/s.",
        "",
        "1 tests, 1 assertions, 0 failures, 0 errors, 0 skips"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  test "one passing test one failing test is red" do
    output =
      [
        "Run options: ",
        "",
        "# Running tests:",
        "",
        "F.",
        "",
        "Finished tests in 0.010978s, 182.1825 tests/s, 182.1825 assertions/s.",
        "",
        "  1) Failure:",
        "test_simple_fail(TestUntitled) [test_untitled.rb:11]:",
        "<54> expected but was",
        "<42>.",
        "",
        "2 tests, 2 assertions, 1 failures, 0 errors, 0 skips"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  test "syntax error of the first kind is amber" do
    output =
      [
        "test_untitled.rb:5:in `<class:TestUntitled>': undefined local variable or method `ddd' for TestUntitled:Class (NameError)",
        "	from test_untitled.rb:4:in `<main>'",
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  test "syntax error of the second kind is amber" do
    output =
      [
        "test_untitled.rb:7: syntax error, unexpected tIDENTIFIER, expecting keyword_do or '{' or '('"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  test "syntax error of the third kind is amber" do
    output =
      [
        "Run options: ",
        "",
        "# Running tests:",
        "",
        "E",
        "",
        "Finished tests in 0.000941s, 1062.6993 tests/s, 0.0000 assertions/s.",
        "",
        "  1) Error:",
        "test_simple(TestUntitled):",
        "ArgumentError: uncaught throw 42",
        "    test_untitled.rb:7:in `throw'",
        "    test_untitled.rb:7:in `test_simple'",
        "",
        "1 tests, 0 assertions, 0 failures, 1 errors, 0 skips"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  def colour_of(output)
    OutputParser::parse_ruby_test_unit(output)
  end
end
