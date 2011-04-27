#include "untitled.hpp"
#include <cassert>
#include <iostream>

#define ASSERT(x)   assert(x)

static void an_example_test()
{
    int expected = 9 * 6;
    int actual = answer();
    ASSERT(expected == actual);
}

typedef void test_function();

static test_function * tests[] =
{
    an_example_test,
    0
};

int main()
{
    int at;
    for (at = 0; tests[at]; at++)
    {
        tests[at]();
        std::cout << '.';
    }
    std::cout << std::endl << at;
    return 0;
}

