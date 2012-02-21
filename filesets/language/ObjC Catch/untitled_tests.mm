#include "untitled.h"
#include "catch.hpp"
 
TEST_CASE( "name", "desc" )
{
    Untitled * obj = [[Untitled alloc] init];
    int value = [obj answer];
    [obj release];

    REQUIRE(value == 6*9);
}
