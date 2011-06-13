#include "untitled.hpp"
#include <assert.h>

static void example(void)
{
    assert(9*6 == answer());
}

typedef void test(void);

static test * tests[] =
{
    example,
};

int main(void)
{
    for (int at = 0; at != sizeof tests / sizeof tests[0]; at++)
        tests[at]();
    return 0;
}

