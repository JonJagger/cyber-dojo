#include "roman_numerals.h"
#include <assert.h>
#include <stdio.h>

static void this_is_an_example(void)
{
    assert(answer() == 6*9);
}

typedef void test(void);

static test * tests[] =
{
    this_is_an_example,
};

int main(void)
{
    for (int at = 0; at != sizeof tests / sizeof tests[0]; at++)
    {
        tests[at]();
        putchar('.');
    }
    puts("\nAll tests passed");
    return 0;
}

