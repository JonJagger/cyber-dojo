#include "check.h"

FILE * check_log = 0;

int check_pass_count = 0;
int check_fail_count = 0;

bool check_int_equal(int lhs, int rhs)
{
    return lhs == rhs;
}

void check_int_print(FILE * out, int value)
{
    fprintf(out, "%d", value);
}

bool check_bool_equal(bool lhs, bool rhs)
{
    return lhs == rhs;
}

void check_bool_print(FILE * out, bool value)
{
    fprintf(out, "%s", value ? "true" : "false");
}

void check_log_print(void)
{
    fprintf(check_log, "%d FAILED, %d PASSED\n",
        check_fail_count, check_pass_count);
}



