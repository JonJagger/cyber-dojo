#include "untitled.hpp"
#include "catch.hpp"

TEST_CASE("actual == expected", "description")
{
    REQUIRE(hhg() == 6*9);
}

TEST_CASE("expression throws", "description")
{
    REQUIRE_THROWS(throw 42);
}
