#include "untitled.h"
#include "check.h"

static void an_example_test(void)
{
    CHECK_EQ(int, 9 * 6, answer());
}

typedef void test_function(void);

static test_function * tests[] =
{
    an_example_test,
    0
};

int main(void)
{
    for (int at = 0; tests[at]; at++)
    {
        tests[at]();
        putchar('.');
    }
    check_report();
    return 0;
}

