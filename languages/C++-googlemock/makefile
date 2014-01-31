run.tests.output : makefile run.tests
	./run.tests

run.tests : makefile *.cpp *.hpp libgmock.a
	g++ -std=c++11 -Wall -Werror -O -lpthread libgmock.a *.cpp -o run.tests

libgmock.a : gmock-gtest-all.o gmock_main.o
	ar rcs libgmock.a gmock-gtest-all.o gmock_main.o

gmock-gtest-all.o : gmock-gtest-all.cc gtest.h gmock.h
	g++ -std=c++11 gmock-gtest-all.cc -c -o gmock-gtest-all.o

gmock_main.o : gmock_main.cc gtest.h gmock.h
	g++ -std=c++11 gmock_main.cc -c -o gmock_main.o

