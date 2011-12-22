#include "untitled.h"
#include <assert.h>
#include <stdio.h>

static void example(void)
{
    assert(hhg() == 6*9);
}

typedef void test(void);

static test * tests[] =
{
    example,
};

int main(void)
{
    size_t at;
    for (at = 0; at != sizeof tests / sizeof tests[0]; at++)
    {
        tests[at]();
        putchar('.');
    }
    printf("\n%zd tests passed", at);
    return 0;
}

