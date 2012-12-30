# encoding: iso-8859-1
require File.dirname(__FILE__) + '/../test_helper'
require 'CodeOutputParser'

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
  
  #--------------------------------------------------------
  
  test "python failing test is red" do
    output = 
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
    assert_equal :red, CodeOutputParser::parse_python_unittest(output)
  end
  
  test "python one test passed and none failing is green" do
    output = 
      [
        ".",
        "----------------------------------------------------------------------",
        "Ran 1 test in 0.000s",
        "",
        "OK"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_python_unittest(output)    
  end
  
  test "python two tests passed and none failing is green" do    
    output = 
      [
        "..",
        "----------------------------------------------------------------------",
        "Ran 2 tests in 0.000s",
        "",
        "OK"
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_python_unittest(output)        
  end
  
  test "python one passing test and one failing test is red" do
    output = 
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
    assert_equal :red, CodeOutputParser::parse_python_unittest(output)            
  end
  
  test "python syntax error is amber" do
    output =
    [
      "Traceback (most recent call last):",
      '  File "test_untitled.py", line 1, in <module>',
      "    import untitled",
      '  File "/Users/jonjagger/Desktop/Repos/cyberdojo/sandboxes/AB/2ED984F2/hippo/untitled.py", line 4',
      "    return 42sdsdsdsd",
      "                    ^",
      "SyntaxError: invalid syntax"      
    ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_python_unittest(output)                
  end
  
  #--------------------------------------------------------

  test "perl one failing test is red" do
    output =
      [
        "#   Failed test 'Life, the universe, and everything'",
        "#   at untitled.t line 7.",
        "# Looks like you failed 1 test of 1.",
        "untitled.t .. ",
        "Dubious, test returned 1 (wstat 256, 0x100)",
        "Failed 1/1 subtests ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 256 Tests: 1 Failed: 1)",
        "  Failed test:  1",
        "  Non-zero exit status: 1",
        "Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.02 cusr  0.01 csys =  0.06 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 1/1 subtests failed."
     ].join("\n")
    assert_equal :red, CodeOutputParser::parse_perl_test_simple(output)                    
  end
  
  test "perl one passing test is green" do
    output =
      [
        "untitled.t .. ok",
        "All tests successful.",
        "Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.05 CPU)",
        "Result: PASS"    
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_perl_test_simple(output)                        
  end
  
  test "perl one passing test and one failing test is red" do
    output =
      [
        "#   Failed test 'Life, the universe, and everything'",
        "#   at untitled.t line 9.",
        "# Looks like you failed 1 test of 2.",
        "untitled.t .. ",
        "Dubious, test returned 1 (wstat 256, 0x100)",
        "Failed 1/2 subtests ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 256 Tests: 2 Failed: 1)",
        "  Failed test:  2",
        "  Non-zero exit status: 1",
        "Files=1, Tests=2,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.05 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 1/2 subtests failed."      
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_perl_test_simple(output)                            
  end
  
  test "perl syntax error is amber" do
    output =
      [
        'Bareword found where operator expected at untitled.t line 7, near "7sss"',
        "	(Missing operator before sss?)",
        'syntax error at untitled.t line 7, near "7sss"',
        "Execution of untitled.t aborted due to compilation errors.",
        "# Looks like your test exited with 255 before it could output anything.",
        "untitled.t .. ",
        "Dubious, test returned 255 (wstat 65280, 0xff00)",
        "No subtests run ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 65280 Tests: 0 Failed: 0)",
        "  Non-zero exit status: 255",
        "  Parse errors: No plan found in TAP output",
        "Files=1, Tests=0,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.06 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 0/0 subtests failed.",      
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_perl_test_simple(output)                                
  end
  
  test "perl aborted due to compilation errors is amber" do
    output =
      [
        'Bareword "sss" not allowed while "strict subs" in use at untitled.t line 8.',
        "Execution of untitled.t aborted due to compilation errors.",
        "# Looks like your test exited with 255 before it could output anything.",
        "untitled.t .. ",
        "Dubious, test returned 255 (wstat 65280, 0xff00)",
        "No subtests run ",
        "",
        "Test Summary Report",
        "-------------------",
        "untitled.t (Wstat: 65280 Tests: 0 Failed: 0)",
        "  Non-zero exit status: 255",
        "  Parse errors: No plan found in TAP output",
        "Files=1, Tests=0,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.01 csys =  0.05 CPU)",
        "Result: FAIL",
        "Failed 1/1 test programs. 0/0 subtests failed."
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_perl_test_simple(output)                                    
  end
  
  #--------------------------------------------------------

  test "erlang one fail is red" do
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
    assert_equal :red, CodeOutputParser::parse_eunit(output)
  end
  
  test "erlang one pass is green" do    
    output =
      [
        "  Test passed."        
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_eunit(output)    
  end
  
  test "erlang two passes is green" do    
    output =
      [
        "  All 2 tests passed."        
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_eunit(output)    
  end
  
  test "erlang one pass one fail is red" do
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
    assert_equal :red, CodeOutputParser::parse_eunit(output)      
  end
  
  test "erlang syntax error is amber" do
    output =
      [
        "./untitled_tests.erl:5: function ddd/1 undefined",
        "make: *** [untitled_tests.beam] Error 1"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_eunit(output)          
  end
  
  test "erlang makefile error is amber" do
    output =
      [
      "Makefile:8: *** missing separator.  Stop."        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_eunit(output)          
  end
  
  #--------------------------------------------------------

  test "PHP one fail is red" do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        "F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer",
        "Failed asserting that <integer:42> matches expected <integer:54>.",
        "",
        "/var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php:10",
        "",
        "FAILURES!",
        "Tests: 1, Assertions: 1, Failures: 1."
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_php_unit(output)      
  end

  test "PHP one pass is green" do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        ".",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "OK (1 test, 1 assertion)"        
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_php_unit(output)            
  end
  
  test "PHP syntax error is amber" do
    output =
      [
        "PHP Parse error:  syntax error, unexpected T_STRING in /var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php on line 10"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_php_unit(output)                  
  end

  test "PHP one pass one fail is red" do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        ".F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer2",
        "Failed asserting that <integer:42> matches expected <integer:54>.",
        "",
        "/var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php:15",
        "",
        "FAILURES!",
        "Tests: 2, Assertions: 2, Failures: 1."        
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_php_unit(output)  
  end

  test "PHP multiple calls in cyber-dojo.sh and one overall-pass and one overall-fail" do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        "F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer",
        "Failed asserting that <integer:42> matches expected <integer:426>.",
        "",
        "/var/www/cyberdojo/sandboxes/67/0194C272/zebra/UntitledTest.php:10",
        "",
        "FAILURES!",
        "Tests: 1, Assertions: 1, Failures: 1.",
        "",
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "SecondTest",
        ".",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "OK (1 test, 1 assertion)",
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_php_unit(output)        
  end

  test "PHP red output then amber output is amber" do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "UntitledTest",
        "F",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "There was 1 failure:",
        "",
        "1) UntitledTest::testAnswer",
        "Failed asserting that <integer:42> matches expected <integer:426>.",
        "",
        "/var/www/cyberdojo/sandboxes/67/0194C272/zebra/UntitledTest.php:10",
        "",
        "FAILURES!",
        "Tests: 1, Assertions: 1, Failures: 1.",
        "",
        "PHP Parse error:  syntax error, unexpected T_STRING in /var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php on line 10"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_php_unit(output)            
  end

  test "PHP green output then amber output is amber" do
    output =
      [
        "PHPUnit 3.4.5 by Sebastian Bergmann.",
        "",
        "SecondTest",
        ".",
        "",
        "Time: 0 seconds, Memory: 4.00Mb",
        "",
        "OK (1 test, 1 assertion)",
        "",
        "PHP Parse error:  syntax error, unexpected T_STRING in /var/www/cyberdojo/sandboxes/52/431F0275/zebra/UntitledTest.php on line 10"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_php_unit(output)            
  end

  #--------------------------------------------------------

  test "haskell one fail is red" do
    output =
      [
        "Cases: 1  Tried: 0  Errors: 0  Failures: 0",
        "",
        "### Failure in: 0",
        "Testing answer",
        "expected: 54",
         "but got: 42",
        "Cases: 1  Tried: 1  Errors: 0  Failures: 1",
        "Counts {cases = 1, tried = 1, errors = 0, failures = 1}"       
      ].join("\n")      
    assert_equal :red, CodeOutputParser::parse_hunit(output)  
  end
  
  test "haskell one pass is green" do
    output =
      [
        "Cases: 1  Tried: 0  Errors: 0  Failures: 0",
        "",                                          
        "Cases: 1  Tried: 1  Errors: 0  Failures: 0",
        "Counts {cases = 1, tried = 1, errors = 0, failures = 0}"        
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_hunit(output)        
  end
  
  test "haskell one pass one fail is red" do
    output =
      [
        "Cases: 2  Tried: 0  Errors: 0  Failures: 0",
        "Cases: 2  Tried: 1  Errors: 0  Failures: 0",
        "",                                          
        "### Failure in: 1",
        "Testing answer",
        "expected: 54",
        " but got: 42",
        "Cases: 2  Tried: 2  Errors: 0  Failures: 1",
        "Counts {cases = 2, tried = 2, errors = 0, failures = 1}"        
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_hunit(output)        
  end
  
  test "haskell syntax error is amber" do
    output =
      [
        "test_Untitled.hs:8:31: Not in scope: `answer2_test'"        
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_hunit(output)                        
  end
  
  #--------------------------------------------------------

  test "clojure one fail is red" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors."
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_clojure_test(output)              
  end

  test "clojure one error is red" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 1 errors.",
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_clojure_test(output)              
  end

  test "clojure no fails and one pass is green" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors."
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_clojure_test(output)              
  end

  test "clojure one fail on 1st test and no fails on 2nd test is red" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors.",
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_clojure_test(output)                  
  end
  
  test "clojure no fails on 1st test and one fail on 2nd test is red" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors.",
      ].join("\n")
    assert_equal :red, CodeOutputParser::parse_clojure_test(output)                  
  end

  test "clojure no fails on 1st test and no fail on 2nd test is green" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
      ].join("\n")
    assert_equal :green, CodeOutputParser::parse_clojure_test(output)                  
  end

  test "clojure mix of amber and red is amber" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "1 failures, 0 errors.",
        "Exception in thread"
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_clojure_test(output)                      
  end
  
  test "clojure mix of amber and green is amber" do
    output =
      [
        "Ran 1 tests containing 1 assertions.",
        "0 failures, 0 errors.",
        "Exception in thread"
      ].join("\n")
    assert_equal :amber, CodeOutputParser::parse_clojure_test(output)                      
  end

end


