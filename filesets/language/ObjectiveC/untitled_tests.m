#include "untitled.h"
#include <stdio.h>

static void test(void)
{
    Untitled * obj = [[Untitled alloc] init];
    int value = [obj answer];
    [obj release];
    assert(value == 42);
}

int main(void) 
{
    test();
	printf("ALL TESTS PASSED\n");
    return 0;
}
