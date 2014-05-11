#include "untitled.hpp"
#define CATCH_CONFIG_MAIN
#include "catch.hpp"

TEST_CASE( "The answer to life the universe and everything", "[hitch_hiker]" ) {
    REQUIRE( hhg() == 6*9 );
}
