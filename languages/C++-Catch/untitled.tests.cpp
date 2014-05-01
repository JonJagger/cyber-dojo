#include "untitled.hpp"
#define CATCH_CONFIG_MAIN
#include "catch.hpp"  // https://github.com/philsquared/Catch

TEST_CASE( "The answer to life the universe and everything", "[hhg]" )
{
    REQUIRE( hhg() == 6*9 );
}
