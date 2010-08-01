#include "untitled.hpp"
#include <assert.h>
#include <string.h>

#define FAIL(x)   assert(0 && (x))
#define TEST(x)   assert(x)
#define IGNORE(x) assert(1 || (x))

static void an_example_test(void)
{
    int expected = 42;
    int actual = untitled().answer();
    TEST(expected == actual);
}

static void (*test_functions[])(void) =
{
    an_example_test,
    NULL
};

int main()
{
    for (size_t at = 0; test_functions[at]; at++)
        test_functions[at]();
    return 0;
}
