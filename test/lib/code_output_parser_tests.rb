# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

class CodeOutputParserTests < ActionController::TestCase
  
  include CodeOutputParser
  
  test "was a red ruby case" do
    red_output =
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
    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(red_output)
  end

  test "ruby one failing test no passing tests is red" do
    red_output =
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
    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(red_output)
  end

  test "ruby one passing test no failing test is green" do
    green_output =
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
    assert_equal :green, CodeOutputParser::parse_ruby_test_unit(green_output)    
  end
  
  test "ruby one passing test one failing test is red" do
    red_output =
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
    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(red_output)    
  end

  test "ruby syntax error is amber" do
    amber_output =
      [
        "test_untitled.rb:7: syntax error, unexpected tIDENTIFIER, expecting keyword_do or '{' or '('"    
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_ruby_test_unit(amber_output)        
  end
  
  #--------------------------------------------------------

  test "nunit RED" do
    # There are two NUnit output formats depending on what
    # version you're using and possibly whether you're on
    # a windows box on are running on Mono
    red_output_1 = 'Tests run: 1, Failures: 1'
    assert_equal :red, CodeOutputParser::parse_nunit(red_output_1)
    red_output_2 = 'Tests run: 3, Errors: 0, Failures: 3'
    assert_equal :red, CodeOutputParser::parse_nunit(red_output_2)
  end

  test "nunit GREEN" do
    green_output_1 = 'Tests run: 1, Failures: 0'
    assert_equal :green, CodeOutputParser::parse_nunit(green_output_1)
    green_output_2 = 'Tests run: 3, Errors: 0, Failures: 0'
    assert_equal :green, CodeOutputParser::parse_nunit(green_output_2)
  end
  
  test "nunit AMBER" do
    amber_output = 'error CS1525: Unexpected symbol ss'
    assert_equal :amber, CodeOutputParser::parse_nunit(amber_output)
  end
  
  #--------------------------------------------------------

  test "catch RED" do
    red_output = "[Testing completed. All 1 test(s) failed]"
    assert_equal :red, CodeOutputParser::parse_catch(red_output)
  end

  test "catch GREEN" do
    green_output = "[Testing completed. All 1 test(s) succeeded]"
    assert_equal :green, CodeOutputParser::parse_catch(green_output)
  end
  
  test "catch RED one pass one fail" do
    red_output = "[Testing completed. 1 test(s) passed but 1 test(s) failed]"
    assert_equal :red, CodeOutputParser::parse_catch(red_output)
  end
  
  test "catch AMBER" do
    amber_output =
      [
        "untitled.tests.cpp: In function 'void catch_internal_TestFunction5()':",
        "untitled.tests.cpp:7: error: 'typo' was not declared in this scope",
        "untitled.tests.cpp:8: error: expected `;' before '}' token",
        "make: *** [run.tests] Error 1"
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_catch(amber_output)
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
    red_output =
      [
        "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
        "./run.tests",
        "Assertion failed: (hhg() == 6*9), function example, file untitled.tests.c, line 7.",
        "make: *** [run.tests.output] Abort trap: 6"    
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_cassert(red_output)        
  end
  
  test "c_assert syntax error is amber" do
    amber_output =
      [
        "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
        "untitled.tests.c: In function 'example':",
        "untitled.tests.c:7: error: 'ssss' undeclared (first use in this function)",
        "untitled.tests.c:7: error: (Each undeclared identifier is reported only once",
        "untitled.tests.c:7: error: for each function it appears in.)",
        "untitled.tests.c:8: error: expected ';' before '}' token",
        "make: *** [run.tests] Error 1"        
      ].join("\n")    
    assert_equal :amber, CodeOutputParser::parse_cassert(amber_output)        
  end
  
  test "c_assert makefile error is amber" do
    amber_output =
      [
        "makefile:3: *** missing separator.  Stop."
      ].join("\n")    
    assert_equal :amber, CodeOutputParser::parse_cassert(amber_output)            
  end
  
  test "c_assert throws exception so make fails is amber" do
    amber_output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "terminate called after throwing an instance of 'std::out_of_range'",
        "  what():  vector::_M_range_check",
        "make: *** [run.tests.output] Aborted"
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_cassert(amber_output)    
  end
    
  test "c_assert two passes is green" do
    green_output =
      [
        "g++ -Wall -Werror -O *.cpp -o run.tests",
        "./run.tests",
        "..",
        "2 tests passed"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_cassert(green_output)        
  end
  
  #--------------------------------------------------------
  
  test "junit failing test is red" do
    red_output =
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
    assert_equal :red, CodeOutputParser::parse_junit(red_output)            
  end

  test "junit syntax error is amber" do
    amber_output =
      [
        "UntitledTest.java:8: ';' expected",
        "        int expected = 6 * 7s;",
        "                            ^",
        "1 error"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_junit(amber_output)                
  end
  
  test "junit passing test is green" do
    green_output =
      [
        "JUnit version 4.11-SNAPSHOT-20120416-1530",
        ".",
        "Time: 0.009",
        "",
        "OK (1 test)"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_junit(green_output)                
  end
  
  #--------------------------------------------------------
  
  test "python failing test is red" do
    red_output = 
      [
        "F",
        "======================================================================",
        "FAIL: test_str (__main__.TestUntitled)",
        "simple example to start you off",
        "----------------------------------------------------------------------",
        "Traceback (most recent call last):",
        '  File "test_untitled.py", line 9, in test_str',
        "    self.assertEqual(6 * 9, obj.answer())",
        "AssertionError: 54 != 42",
        "",
        "----------------------------------------------------------------------",
        "Ran 1 test in 0.000s",
        "",
        "FAILED (failures=1)"
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_python_unittest(red_output)
  end
  
  test "python one test passed and none failing is green" do
    green_output = 
      [
        ".",
        "----------------------------------------------------------------------",
        "Ran 1 test in 0.000s",
        "",
        "OK"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_python_unittest(green_output)    
  end
  
  test "python two tests passed and none failing is green" do    
    green_output = 
      [
        "..",
        "----------------------------------------------------------------------",
        "Ran 2 tests in 0.000s",
        "",
        "OK"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_python_unittest(green_output)        
  end
  
  test "python one passing test and one failing test is red" do
    red_output = 
      [
        ".F",
        "======================================================================",
        "FAIL: test_str2 (__main__.TestUntitled)",
        "simple example to start you off",
        "----------------------------------------------------------------------",
        "Traceback (most recent call last):",
        '  File "test_untitled.py", line 14, in test_str2',
        "    self.assertEqual(6 * 9, obj.answer())",
        "AssertionError: 54 != 42",
        "",
        "----------------------------------------------------------------------",
        "Ran 2 tests in 0.000s",
        "",
        "FAILED (failures=1)"
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_python_unittest(red_output)            
  end
  
  test "python syntax error is amber" do
    amber_output =
    [
      "Traceback (most recent call last):",
      '  File "test_untitled.py", line 1, in <module>',
      "    import untitled",
      '  File "/Users/jonjagger/Desktop/Repos/cyberdojo/sandboxes/AB/2ED984F2/hippo/untitled.py", line 4',
      "    return 42sdsdsdsd",
      "                    ^",
      "SyntaxError: invalid syntax"      
    ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_python_unittest(amber_output)                
  end
  
end


