#include "untitled.hpp"
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
    check_log = stderr;
    RUN_ALL(tests);
    check_log_print();
    return 0;
}


