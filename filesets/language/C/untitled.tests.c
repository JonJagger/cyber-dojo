#include "untitled.h"
#include "check.h"

static void example(void)
{
    CHECK_NE(int, 9 * 6, answer());
    CHECK_EQ(int, 9 * 6, answer());
}

typedef void test(void);

static test * tests[] =
{
    example,
};

int main(void)
{
    RUN_ALL(tests);
    check_report();
    return 0;
}

