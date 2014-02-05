run.tests.output : makefile run.tests
	./run.tests

run.tests : makefile *.cpp *.hpp gtest_main.a
	g++ -I. -std=c++11 -Wall -Werror -O -lpthread gmock_main.a *.cpp -o run.tests
