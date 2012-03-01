run.tests.output : run.tests
    ./run.tests

run.tests : *.m *.mm *.cpp
    g++ -Wall -Werror *.cpp *.m *.mm -framework Foundation -o run.tests
