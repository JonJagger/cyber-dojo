require File.dirname(__FILE__) + '/../test_helper'
require 'parse_run_tests_output_helper'

# > ruby test/functional/parse_run_tests_output_tests.rb

class ParseRunTestsOutputTests < ActionController::TestCase
  
  include ParseRunTestsOutputHelper
  
  def test_was_a_red_ruby_case

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

    assert_equal :red, parse_ruby_test_unit(output)

  end

  def test_nunit_RED_failed
    # There are two NUnit output formats depending on what
    # version you're using and possibly whether you're on
    # a windows box on are running on Mono
    red_output_1 = 'Tests run: 1, Failures: 1'
    assert_equal :red, parse_nunit(red_output_1)
    red_output_2 = 'Tests run: 3, Errors: 0, Failures: 3'
    assert_equal :red, parse_nunit(red_output_2)
  end

  def test_nunit_GREEN_passed
    green_output_1 = 'Tests run: 1, Failures: 0'
    assert_equal :green, parse_nunit(green_output_1)
    green_output_2 = 'Tests run: 3, Errors: 0, Failures: 0'
    assert_equal :green, parse_nunit(green_output_2)
  end
  
  def test_nunit_AMBER_error
    amber_output = 'error CS1525: Unexpected symbol ss'
    assert_equal :amber, parse_nunit(amber_output)
  end
  
  def test_catch_RED_failed
    red_output = "[Testing completed. All 1 test(s) failed]"
    assert_equal :red, parse_catch(red_output)
  end

  def test_catch_GREEN_passed
    green_output = "[Testing completed. All 1 test(s) succeeded]"
    assert_equal :green, parse_catch(green_output)
  end
  
  def test_catch_RED_one_pass_one_fail
    red_output = "[Testing completed. 1 test(s) passed but 1 test(s) failed]"
    assert_equal :red, parse_catch(red_output)
  end
  
  def test_catch_AMBER
amber_output = <<HERE    
untitled.tests.cpp: In function Ôvoid catch_internal_TestFunction5()Õ:
untitled.tests.cpp:7: error: ÔtypoÕ was not declared in this scope
untitled.tests.cpp:8: error: expected `;' before Ô}Õ token
make: *** [run.tests] Error 1
HERE
    assert_equal :amber, parse_catch(amber_output)
  end
  
end 

