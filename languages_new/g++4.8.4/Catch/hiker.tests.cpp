#include <hiker.hpp>
#define CATCH_CONFIG_MAIN
#include "catch.hpp"  // https://github.com/philsquared/Catch

TEST_CASE( "Life the universe and everything", "[hhgttg]" )
{
    REQUIRE( answer() == 42 );
}
