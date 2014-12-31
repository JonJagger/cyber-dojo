#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputCppGoogleTestTests < AppLibTestBase

  test 'initial red is red' do
    output =
    [
      "Running main() from gmock_main.cc",
      "[==========] Running 1 test from 1 test case.",
      "[----------] Global test environment set-up.",
      "[----------] 1 test from UntitledTest",
      "[ RUN      ] UntitledTest.HitchHiker",
      "untitled.tests.cpp:8: Failure",
      "Value of: hhg()",
      "  Actual: 42",
      "Expected: 6 * 9",
      "Which is: 54",
      "[  FAILED  ] UntitledTest.HitchHiker (0 ms)",
      "[----------] 1 test from UntitledTest (0 ms total)",
      "",
      "[----------] Global test environment tear-down",
      "[==========] 1 test from 1 test case ran. (0 ms total)",
      "[  PASSED  ] 0 tests.",
      "[  FAILED  ] 1 test, listed below:",
      "[  FAILED  ] UntitledTest.HitchHiker",
      "",
      " 1 FAILED TEST",
      "make: *** [run.tests.output] Error 1"
    ].join("\n")
    assert_equal :red, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'initial amber is amber' do
    output =
    [
      "untitled.cpp: In function 'int hhg()':",
      "untitled.cpp:5:12: error: unable to find numeric literal operator 'operator\"\" typo2'",
      "untitled.cpp:6:1: error: control reaches end of non-void function [-Werror=return-type]",
      "cc1plus: all warnings being treated as errors",
      "make: *** [run.tests] Error 1"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'initial green is green' do
    output =
    [
      "Running main() from gmock_main.cc",
      "[==========] Running 1 test from 1 test case.",
      "[----------] Global test environment set-up.",
      "[----------] 1 test from UntitledTest",
      "[ RUN      ] UntitledTest.HitchHiker",
      "[       OK ] UntitledTest.HitchHiker (0 ms)",
      "[----------] 1 test from UntitledTest (0 ms total)",
      "",
      "[----------] Global test environment tear-down",
      "[==========] 1 test from 1 test case ran. (0 ms total)",
      "[  PASSED  ] 1 test."
    ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_google_test(output)
  end

end
