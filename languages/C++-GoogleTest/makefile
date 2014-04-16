CXXFLAGS += -g -std=c++11 -Wall -Wextra -pthread
GTEST_LIBS = -lgtest -lgtest_main

run.tests.output : makefile run.tests
	./run.tests

run.tests : makefile *.cpp *.hpp
	$(CXX) -I. $(CXXFLAGS) -O *.cpp $(GTEST_LIBS) -o $@
