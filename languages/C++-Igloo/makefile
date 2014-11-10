CXXFLAGS += -g -std=c++11 -Wall -Wextra -Werror -pthread

run.tests.output : makefile run.tests
	./run.tests

run.tests : makefile *.cpp *.hpp
	$(CXX) -I. $(CXXFLAGS) -O *.cpp -o $@
