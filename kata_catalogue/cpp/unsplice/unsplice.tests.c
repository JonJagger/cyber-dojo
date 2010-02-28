#include "unsplice.h"
#include <assert.h>
#include <string.h>

#define   FAIL_TEST(x) assert(0 && (x))
#define ASSERT_TEST(x) assert(x)
#define IGNORE_TEST(x) assert(1 || (x))

void unsplice_tests(void)
{
    const char * expected = "abc";
    char actual[] = "abc";
    unsplice(actual);
    FAIL_TEST(strcmp(actual, expected) == 0);
}

typedef void (*test_function)(void);

const test_function test_functions[] =
{
    unsplice_tests,
	0
};

int main()
{
    for (size_t at = 0; test_functions[at]; at++)
        test_functions[at]();
    return 0;
}

