#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class OutputBoostTests < AppLibTestBase

  test 'one failing test is red' do
    output = <<END_OF_OUTPUT
g++ -x c++ -I. -std=c++11 -Wall -Wextra -Werror -DBOOST_TEST_DYN_LINK -c -o hiker.compiled_hpp hiker.hpp
g++ -I. -std=c++11 -Wall -Wextra -Werror -DBOOST_TEST_DYN_LINK -O hiker.cpp hiker.tests.cpp -lboost_unit_test_framework -o test
./test
Running 1 test case...
hiker.tests.cpp(11): fatal error in "Life_the_universe_and_everything": critical check 42 == answer() failed [42 != 54]

*** 1 failure detected in test suite "HikerTest"
make: *** [test] Error 201
END_OF_OUTPUT
    assert_equal :red, colour_of(output)
  end

  test 'two failing test is red' do
    output = <<END_OF_OUTPUT
g++ -I. -std=c++11 -Wall -Wextra -Werror -DBOOST_TEST_DYN_LINK -O hiker.cpp hiker.tests.cpp -lboost_unit_test_framework -o test
./test
Running 2 test cases...
hiker.tests.cpp(11): fatal error in "Life_the_universe_and_everything": critical check 42 == answer() failed [42 != 33]
hiker.tests.cpp(21): fatal error in "Life_the_universe_and_everything2": critical check 0 == answer() % 2 failed [0 != 1]

*** 2 failures detected in test suite "HikerTest"
make: *** [test] Error 201
END_OF_OUTPUT
    assert_equal :red, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  test 'one passing test is green' do
    output = <<END_OF_OUTPUT
g++ -I. -std=c++11 -Wall -Wextra -Werror -DBOOST_TEST_DYN_LINK -O hiker.cpp hiker.tests.cpp -lboost_unit_test_framework -o test
./test
Running 1 test case...

*** No errors detected
END_OF_OUTPUT
    assert_equal :green, colour_of(output)
  end

  # - - - - - - - - - - - - - - -

  def colour_of(output)
    OutputParser::parse_boost_test(output)
  end

end
