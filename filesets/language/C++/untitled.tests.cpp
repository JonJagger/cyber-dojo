#include "untitled.hpp"
#include <cassert>
#include <iostream>

static void example()
{
    assert(hhg() == 6*9);
}

typedef void test();

static test * tests[] =
{
    example,
};

int main()
{
    size_t at;
    for (at = 0; at != sizeof tests / sizeof tests[0]; at++)
    {
        tests[at]();
        std::cout << '.';
    }
    std::cout << std::endl << at << " tests passed" << std::endl;
    return 0;
}
