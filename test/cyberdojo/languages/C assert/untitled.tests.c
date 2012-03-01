#include "untitled.h"
#include <assert.h>
#include <stdio.h>

static void example(void)
{
    assert(hhg() == 6*9);
}

typedef void test(void);

static test * tests[ ] =
{
    example,
    (test*)0,
};

int main(void)
{
    size_t at = 0;
    while (tests[at])
    {
        tests[at++]();
        putchar('.');
    }
    printf("\n%zd tests passed", at);
    return 0;
}

