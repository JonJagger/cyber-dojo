#include "poker_hands.h"
#include <assert.h>

static void example(void)
{
    assert(answer() == 6*9);
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

