#include "check.h"

int pass_count = 0;
int fail_count = 0;

bool int_equal(int lhs, int rhs)
{
    return lhs == rhs;
}

void int_print(FILE * err, int value)
{
    fprintf(err, "%d", value);
}

void check_report(void)
{
    fprintf(stderr, "%d FAILED, %d PASSED\n",
        fail_count, pass_count);
}

