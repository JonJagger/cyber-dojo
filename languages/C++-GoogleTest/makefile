CXXFLAGS += -g -std=c++11 -Wall -Wextra -Werror -pthread
GTEST_LIBS = -lgtest -lgtest_main

HPP_FILES = $(wildcard *.hpp)
XPP_FILES = $(patsubst %.hpp,%.xpp,$(HPP_FILES))
CPP_FILES = $(wildcard *.cpp)
OBJ_FILES = $(patsubst %.cpp,%.o,$(CPP_FILES))

test: makefile $(CPP_FILES) $(XPP_FILES)
	$(CXX) -I. $(CXXFLAGS) -O $(CPP_FILES) $(GTEST_LIBS) -o $@
	./$@ --gtest_shuffle

# This rule ensures header files build in their own right.
# The quality of header files is important because header files
# are #included from other files and thus have a large span
# of influence (unlike .cpp files which are not #included)

%.xpp: %.hpp
	$(CXX) -I. $(CXXFLAGS) $< -o $@
