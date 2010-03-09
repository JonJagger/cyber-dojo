#include "unsplice.h"
#include <assert.h>
#include <string.h>

#define   FAIL(x) assert(0 && (x))
#define ASSERT(x) assert(x)
#define IGNORE(x) assert(1 || (x))

static void line_with_no_splices_is_unchanged(void)
{
    const char * expected = "abc";
    char actual[] = "abc";
    unsplice(actual);
    FAIL(strcmp(actual, expected) == 0);
}

static void (*test_functions[])(void) =
{
    line_with_no_splices_is_unchanged,
    0
};

int main()
{
    for (size_t at = 0; test_functions[at]; at++)
        test_functions[at]();
    return 0;    
}

