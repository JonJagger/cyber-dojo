# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

# If a player creates a cyberdojo.sh file which runs two
# test files then it's possible the first one will pass and
# the second one will have a failure.
# The tests below need to be restructured, one file per
# language, and data driven. Each test file will contain
# an array of green output
# an array of red output, and
# an array of amber output.
# Then the tests should verify that each has its correct
# colour individually, and also that
# any amber + any red => amber
# any amber + any green => amber
# any green + any red => red

class CodeOutputParserTests < ActionController::TestCase
  
  include CodeOutputParser

  test "terminated by the server after 10 seconds is amber" do
    output = "Terminated by the cyber-dojo server after 10 seconds"
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ignored', output)    
  end
  
  test "terminated by the server after 5 seconds is amber" do
    output = "Terminated by the cyber-dojo server after 5 seconds"
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ignored', output)    
  end
  
  test "terminated by the server after 1 second is amber" do
    output = "Terminated by the cyber-dojo server after 1 second"
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ignored', output)    
  end
  
  test "when not terminated unit_test_framework name is used to select parser" do
    output =
      [
        "test_untitled.rb:7: syntax error, unexpected tIDENTIFIER, expecting keyword_do or '{' or '('"    
      ].join("\n")
    expected = { :colour => :amber }
    assert_equal expected, CodeOutputParser::parse('ruby_test_unit', output)        
  end
  
  #--------------------------------------------------------
  
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
    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(output)
  end

  test "ruby one failing test no passing tests is red" do
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
    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(output)
  end

  test "ruby one passing test no failing test is green" do
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
    assert_equal :green, CodeOutputParser::parse_ruby_test_unit(output)    
  end
  
  test "ruby one passing test one failing test is red" do
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
    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(output)    
  end

  test "ruby syntax error is amber" do
    output =
      [
        "test_untitled.rb:7: syntax error, unexpected tIDENTIFIER, expecting keyword_do or '{' or '('"    
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_ruby_test_unit(output)        
  end
  
  #--------------------------------------------------------

  test "nunit RED" do
    # There are two NUnit output formats depending on what
    # version you're using and possibly whether you're on
    # a windows box or are running on Mono
    output_1 = 'Tests run: 1, Failures: 1'
    assert_equal :red, CodeOutputParser::parse_nunit(output_1)
    output_2 = 'Tests run: 3, Errors: 0, Failures: 3'
    assert_equal :red, CodeOutputParser::parse_nunit(output_2)
  end

  test "nunit GREEN" do
    output_1 = 'Tests run: 1, Failures: 0'
    assert_equal :green, CodeOutputParser::parse_nunit(output_1)
    output_2 = 'Tests run: 3, Errors: 0, Failures: 0'
    assert_equal :green, CodeOutputParser::parse_nunit(output_2)
  end
  
  test "nunit AMBER" do
    output = 'error CS1525: Unexpected symbol ss'
    assert_equal :amber, CodeOutputParser::parse_nunit(output)
  end
  
  #--------------------------------------------------------

  test "catch RED" do
    output = "[Testing completed. All 1 test(s) failed]"
    assert_equal :red, CodeOutputParser::parse_catch(output)
  end

  test "catch GREEN" do
    output = "[Testing completed. All 1 test(s) succeeded]"
    assert_equal :green, CodeOutputParser::parse_catch(output)
  end
  
  test "catch RED one pass one fail" do
    output = "[Testing completed. 1 test(s) passed but 1 test(s) failed]"
    assert_equal :red, CodeOutputParser::parse_catch(output)
  end
  
  test "catch AMBER" do
    output =
      [
        "untitled.tests.cpp: In function 'void catch_internal_TestFunction5()':",
        "untitled.tests.cpp:7: error: 'typo' was not declared in this scope",
        "untitled.tests.cpp:8: error: expected `;' before '}' token",
        "make: *** [run.tests] Error 1"
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_catch(output)
  end
  
  #--------------------------------------------------------

  test "go build failed is amber" do
    assert_equal :amber, CodeOutputParser::parse_go_testing("[build failed]")  
  end
  
  test "go ran but failed is green" do
    assert_equal :red, CodeOutputParser::parse_go_testing("FAIL")
  end
  
  test "go ran and passed is red" do
    assert_equal :green, CodeOutputParser::parse_go_testing("PASS")
  end
  
  test "go anything else is amber" do
    assert_equal :amber, CodeOutputParser::parse_go_testing("anything else")
  end
  
  #--------------------------------------------------------
  
  test "c_assert failure is red" do
    output =
      [
        "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
        "./run.tests",
        "Assertion failed: (hhg() == 6*9), function example, file untitled.tests.c, line 7.",
        "make: *** [run.tests.output] Abort trap: 6"    
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_cassert(output)        
  end
  
  test "c_assert syntax error is amber" do
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
    assert_equal :amber, CodeOutputParser::parse_cassert(output)        
  end
  
  test "c_assert makefile error is amber" do
    output =
      [
        "makefile:3: *** missing separator.  Stop."
      ].join("\n")    
    assert_equal :amber, CodeOutputParser::parse_cassert(output)            
  end
  
  test "c_assert throws exception so make fails is amber" do
    output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "terminate called after throwing an instance of 'std::out_of_range'",
        "  what():  vector::_M_range_check",
        "make: *** [run.tests.output] Aborted"
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_cassert(output)    
  end
    
  test "c_assert two passes is green" do
    output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "..",
        "2 tests passed"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_cassert(output)        
  end
  
  #--------------------------------------------------------
  
  test "junit failing test is red" do
    output =
      [
        "JUnit version 4.11-SNAPSHOT-20120416-1530",
        ".E",
        "Time: 0.008",
        "There was 1 failure:",
        "1) hitch_hiker(UntitledTest)",
        "java.lang.AssertionError: expected:<54> but was:<42>",
        "...",
        "",
        "FAILURES!!!",
        "Tests run: 1,  Failures: 1"
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_junit(output)            
  end

  test "junit syntax error is amber" do
    output =
      [
        "UntitledTest.java:8: ';' expected",
        "        int expected = 6 * 7s;",
        "                            ^",
        "1 error"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_junit(output)                
  end
  
  test "junit passing test is green" do
    output =
      [
        "JUnit version 4.11-SNAPSHOT-20120416-1530",
        ".",
        "Time: 0.009",
        "",
        "OK (1 test)"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_junit(output)                
  end
        
end


