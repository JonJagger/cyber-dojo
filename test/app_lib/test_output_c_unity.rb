#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputCUnityTests < AppLibTestBase

  test 'failure is red' do
    output =
      [
         "ruby ~/Unity-master/auto/generate_test_runner.rb hiker.tests.c TestMain.c",
         "gcc -Wall -Wextra -Werror -O -std=c99 -isystem ~/Unity-master/src/ *.c ~/Unity-master/src/unity.c -o run.tests",
         "./run.tests",
         "",
         "hiker.tests.c:15:test_life_the_universe_and_everything:FAIL: Expected 42 Was 54",
         "-----------------------",
         "1 Tests 1 Failures 0 Ignored",
         "FAIL",
         "make: *** [run.tests.output] Error 1"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end
  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the first kind is amber' do
    output =
      [
	"ruby ~/Unity-master/auto/generate_test_runner.rb hiker.tests.c TestMain.c",
	"gcc -Wall -Wextra -Werror -O -std=c99 -I ~/Unity-master/src/ *.c ~/Unity-master/src/unity.c -o run.tests",
	"hiker.c: In function 'answer':",
	"hiker.c:5:18: error: 'x' undeclared (first use in this function)",
	"     return 6 * 9;x",
	"                  ^",
	"hiker.c:5:18: note: each undeclared identifier is reported only once for each function it appears in",
	"hiker.c:6:1: error: expected ';' before '}' token",
	" }",
	" ^",
	"make: *** [run.tests] Error 1"
      ].join("\n")

    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the second kind is amber' do
    output =
    [
	"ruby ~/Unity-master/auto/generate_test_runner.rb hiker.tests.c TestMain.c",
	"gcc -Wall -Wextra -Werror -O -std=c99 -I ~/Unity-master/src/ *.c ~/Unity-master/src/unity.c -o run.tests",
	"hiker.c:2:2: error: invalid preprocessing directive #lone",
	" #lone",
	"  ^",
	"make: *** [run.tests] Error 1"
    ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'makefile error is amber' do
    output =
      [
        "makefile:1: *** missing separator.  Stop."
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'makefile rule error is amber' do
    output =
      [
	"make: *** No rule to make target `create.test.main', needed by `run.tests.output'.  Stop.",
      ].join("\n")
    assert_equal :amber, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'two passes is green' do
    output =
      [
        "ruby ~/Unity-master/auto/generate_test_runner.rb hiker.tests.c TestMain.c",
        "gcc -Wall -Wextra -Werror -O -std=c99 -isystem ~/Unity-master/src/ *.c ~/Unity-master/src/unity.c -o run.tests",
        "./run.tests",
        "",
        "hiker.tests.c:12:test_life_the_universe_and_everything:PASS",
        "-----------------------",
        "1 Tests 0 Failures 0 Ignored",
        "OK"
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_cunity(output)
  end

end
