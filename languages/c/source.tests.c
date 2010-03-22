#include "source.h"
#include <assert.h>
#include <string.h>

#define   FAIL(x) assert(0 && (x))
#define ASSERT(x) assert(x)
#define IGNORE(x) assert(1 || (x))

static void requirement(void)
{
    const char * expected = "abc";
    char actual[] = "abc";
    //...
    FAIL(strcmp(actual, expected) == 0);
}

static void (*test_functions[])(void) =
{
    requirement,
    0
};

int main()
{
    for (size_t at = 0; test_functions[at]; at++)
        test_functions[at]();
    return 0;    
}

