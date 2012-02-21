require File.dirname(__FILE__) + '/../test_helper'
require 'run_tests_output_parser_helper'

# > ruby test/functional/output_parser_tests.rb

class OutputParserTests < ActionController::TestCase
  
  include RunTestsOutputParserHelper
  
  def test_failing_ruby_case

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

    assert_equal :failed, parse_ruby_test_unit(output)

  end

  def test_RED_failed_nunit
    failed_output = 'Tests run: 1, Failures: 1, Not run: 0, Time: 0.079 seconds'
    assert_equal :failed, parse_nunit(failed_output)
  end

  def test_GREEN_passed_nunit
    passed_output = 'Tests run: 1, Failures: 0, Not run: 0, Time: 0.031 seconds'
    assert_equal :passed, parse_nunit(passed_output)
  end
  
  
  def test_RED_failed_catch
    red_output = "[Testing completed. All 1 test(s) failed]"
    assert_equal :failed, parse_catch(red_output)
  end

  def test_GREEN_passed_catch
    green_output = "[Testing completed. All 1 test(s) succeeded]"
    assert_equal :passed, parse_catch(green_output)
  end
  
  def test_RED_one_pass_one_fail_catch
    red_output = "[Testing completed. 1 test(s) passed but 1 test(s) failed]"
    assert_equal :failed, parse_catch(red_output)
  end
  
  def test_AMBER_catch
amber_output = <<HERE    
untitled.tests.cpp: In function Ôvoid catch_internal_TestFunction5()Õ:
untitled.tests.cpp:7: error: ÔtypoÕ was not declared in this scope
untitled.tests.cpp:8: error: expected `;' before Ô}Õ token
make: *** [run.tests] Error 1
HERE
    assert_equal :error, parse_catch(amber_output)
  end
  
end 

