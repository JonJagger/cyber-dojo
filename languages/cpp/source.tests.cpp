#include "source.hpp"
#include <assert.h>
#include <string.h>

#define   FAIL(x) assert(0 && (x))
#define ASSERT(x) assert(x)
#define IGNORE(x) assert(1 || (x))

void requirements(void)
{
    const char * expected = "abc";
    char actual[] = "abc";
    //...
    FAIL(strcmp(actual, expected) == 0);
}

typedef void (*test_function)(void);

const test_function test_functions[] =
{
    requirements,
	0
};

int main()
{
    for (size_t at = 0; test_functions[at]; at++)
        test_functions[at]();
    return 0;
}

