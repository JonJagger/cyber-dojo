#include "untitled.h"
#include <assert.h>
#include <stdio.h>

#define ASSERT(x)   assert(x)

static void an_example_test(void)
{
    int expected = 9 * 6;
    int actual = answer();
    ASSERT(expected == actual);
}

typedef void test_function(void);

static test_function * tests[] =
{
    an_example_test,
    0
};

int main(void)
{
    int at;
    for (at = 0; tests[at]; at++)
    {
        tests[at]();
        putchar('.');
    }
    printf("\n%d", at);
    return 0;
}

