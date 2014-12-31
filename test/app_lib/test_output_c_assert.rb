#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputCAssertTests < AppLibTestBase

  test 'failure is red' do
    output =
      [
        "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
        "./run.tests",
        "Assertion failed: (hhg() == 6*9), function example, file untitled.tests.c, line 7.",
        "make: *** [run.tests.output] Abort trap: 6"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the first kind is amber' do
    output =
      [
        "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
        "untitled.tests.c: In function 'example':",
        "untitled.tests.c:7: error: 'ssss' undeclared (first use in this function)",
        "untitled.tests.c:7: error: (Each undeclared identifier is reported only once",
        "untitled.tests.c:7: error: for each function it appears in.)",
        "untitled.tests.c:8: error: expected ';' before '}' token",
        "make: *** [run.tests] Error 1"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the second kind is amber' do
    output =
    [
      "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
      "untitled.tests.c:5:2: error: invalid preprocessing directive #lone"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'makefile error is amber' do
    output =
      [
        "makefile:3: *** missing separator.  Stop."
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'throws exception so make fails is amber' do
    output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "terminate called after throwing an instance of 'std::out_of_range'",
        "  what():  vector::_M_range_check",
        "make: *** [run.tests.output] Aborted"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'all passes is green' do
    output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "..",
        "All tests passed"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'specific number of passes is green' do
    # some C start files use 'All tests passed'
    # and some (eg Yahtzee refactoring) use 'N tests passed'
    output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "..",
        "4 tests passed"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_cassert(output)
  end

end
