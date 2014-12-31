#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputCPPIglooTests < AppLibTestBase

  test 'failure is red' do
    output =
      [
         "g++ -I. -g -std=c++11 -Wall -Wextra -Werror -pthread -O *.cpp -lgtest -o run.tests",
         "./run.tests",
         "F",
         "",
         "F_0::F_1 failed:",
         "Caught unknown exception",
         "Test run complete. 1 tests run, 0 succeeded, 1 failed.",
         "make: *** [run.tests.output] Error 1"
      ].join("\n")
    assert_equal :red, colour_of(output)
  end
  #- - - - - - - - - - - - - - - - - - - - - -

  test 'syntax error of the first kind is amber' do
    output =
      [
    "g++ -I. -g -std=c++11 -Wall -Wextra -Werror -pthread -O *.cpp -lgtest -o run.tests",
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
    "g++ -I. -g -std=c++11 -Wall -Wextra -Werror -pthread -O *.cpp -lgtest -o run.tests",
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
         "g++ -I. -g -std=c++11 -Wall -Wextra -Werror -pthread -O *.cpp -lgtest -o run.tests",
         "./run.tests",
         "Test run complete. 2 tests run, 2 succeeded, 0 failed.",
      ].join("\n")
    assert_equal :green, colour_of(output)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_cppigloo(output)
  end

end
