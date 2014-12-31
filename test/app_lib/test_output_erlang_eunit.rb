#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputErlangEUnitTests < AppLibTestBase

  test 'one fail is red' do
    output =
      [
        "untitled_tests: answer_test (module 'untitled_tests')...*failed*",
        "::error:{assertEqual_failed,[{module,untitled_tests},",
        "                           {line,6},",
        '                           {expression,"untitled : answer ( )"},',
        "                           {expected,54},",
        "                           {value,42}]}",
        "  in function untitled_tests:'-answer_test/0-fun-0-'/1",
        "",
        "",
        "=======================================================",
        "  Failed: 1.  Skipped: 0.  Passed: 0."
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one pass is green' do
    output =
      [
        "  Test passed."
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'two passes is green' do
    output =
      [
        "  All 2 tests passed."
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'one pass one fail is red' do
    output =
      [
        "untitled_tests: answer2_test...*failed*",
        "::error:{assertEqual_failed,[{module,untitled_tests},",
        "                           {line,10},",
        '                           {expression,"untitled : answer ( )"},',
        '                           {expected,54},',
        '                           {value,42}]}',
        "  in function untitled_tests:'-answer2_test/0-fun-0-'/1",
        "",
        "",
        "=======================================================",
        "  Failed: 1.  Skipped: 0.  Passed: 1."
      ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error is amber' do
    output =
      [
        "./untitled_tests.erl:5: function ddd/1 undefined",
        "make: *** [untitled_tests.beam] Error 1"
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'makefile error is amber' do
    output =
      [
      "Makefile:8: *** missing separator.  Stop."
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_eunit(output)
  end

end
