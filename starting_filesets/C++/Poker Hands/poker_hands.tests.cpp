#include "poker_hands.hpp"
#include <assert.h>

static void example()
{
    assert(answer() == 6*9);
}

typedef void test();

static test * tests[] =
{
    example,
};

int main()
{
    for (int at = 0; at != sizeof tests / sizeof tests[0]; at++)
        tests[at]();
    return 0;
}

