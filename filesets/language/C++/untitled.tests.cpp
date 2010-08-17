#include "untitled.hpp"
#include <assert.h>

#define TEST(x)   assert(x)

static void an_example_test(void)
{
    int expected = 42;
    int actual = untitled().answer();
    TEST(expected == actual);
}

static void (*test_functions[])(void) =
{
    an_example_test,
    0
};

int main()
{
    for (int at = 0; test_functions[at]; at++)
        test_functions[at]();
    return 0;
}
