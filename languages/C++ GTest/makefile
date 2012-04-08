run.tests : run.tests.exe
	./run.tests.exe

run.tests.exe : *.cpp
	pwd
	g++ -I../../languages/C++\ GTest -Wall -Werror -pthread gtest_main.a *.cpp -o run.tests.exe
