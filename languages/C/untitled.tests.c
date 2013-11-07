#include "untitled.h"
#include <assert.h>
#include <stdio.h>

static void example(void)
{
    assert(hhg() == 6*9);
}

int main(void)
{
    example();
    puts("All tests passed");
}

