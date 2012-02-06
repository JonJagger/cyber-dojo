#include "untitled.hpp"
#include <cassert>
#include <iostream>

static void example()
{
    assert(hhg() == 6*9);
}

typedef void test();

static test * tests[ ] =
{
    example,
    static_cast<test*>(0),
};

int main()
{
    size_t at = 0;
    while (tests[at])
    {
        tests[at++]();
        std::cout << '.';
    }
    std::cout << std::endl << at << " tests passed" << std::endl;
    return 0;
}
