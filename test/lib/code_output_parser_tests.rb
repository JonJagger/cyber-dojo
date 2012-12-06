# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

class CodeOutputParserTests < ActionController::TestCase
  
  include CodeOutputParser
  
  test "was a red ruby case" do

output = <<HERE
Loaded suite test_get_digits
Started
F...........F.F..
Finished in 0.01447 seconds.
<"     _   _ \n  | | | |_|\n  | |_|   |">.
<" _     \n| |   |\n|_|   |">.
  3) Failure:
<" _   _ \n  |  _|\n  | |_ ">.
17 tests, 17 assertions, 3 failures, 0 errors

  2) Failure:
test_ten(TestGetDigits) [test_get_digits.rb:81]:
<"     _ \n  | | |\n  | |_|"> expected but was
<" _     \n| |   |\n|_|   |">.

  3) Failure:
test_twenty_seven(TestGetDigits) [test_get_digits.rb:95]:
<" _   _ \n _|   |\n|_    |"> expected but was
<" _   _ \n  |  _|\n  | |_ ">.

17 tests, 17 assertions, 3 failures, 0 errors
[[" _ ", " _ "], ["  |", " _|"], ["  |", "|_ "]]
HERE

    assert_equal :red, CodeOutputParser::parse_ruby_test_unit(output)

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
amber_output = <<HERE    
untitled.tests.cpp: In function Ôvoid catch_internal_TestFunction5()Õ:
untitled.tests.cpp:7: error: ÔtypoÕ was not declared in this scope
untitled.tests.cpp:8: error: expected `;' before Ô}Õ token
make: *** [run.tests] Error 1
HERE
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
  
  test "was a green C/C++ assert case" do
amber_output = <<HERE    
g++ -Wall -Werror -O *.cpp -o run.tests
./run.tests
terminate called after throwing an instance of 'std::out_of_range'
  what():  vector::_M_range_check
make: *** [run.tests.output] Aborted
HERE
    assert_equal :amber, CodeOutputParser::parse_cassert(amber_output)    
  end
  
  #--------------------------------------------------------
  
  test "another green C/C++ assert case" do
green_output = <<HERE    
g++ -Wall -Werror -O *.cpp -o run.tests
./run.tests
..
2 tests passed
HERE
    assert_equal :green, CodeOutputParser::parse_cassert(green_output)        
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


