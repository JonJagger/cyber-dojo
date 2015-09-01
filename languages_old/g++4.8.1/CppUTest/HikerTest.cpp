#include "Hiker.hpp"
#include "CppUTest/TestHarness.h"

TEST_GROUP(Hiker)
{
    Hiker * hhg;

    void setup()
    {
        hhg = new Hiker();
    }
    void teardown()
    {
        delete hhg;
    }
};

TEST(Hiker, Life_the_universe_and_everything)
{
    // a simple example to start you off
    LONGS_EQUAL(42, hhg->answer());
    //CHECK(1);
    //CHECK_TRUE(1);
    //CHECK_FALSE(0);
    //STRCMP_EQUAL("hey", "hey");
    //FAIL("Start here");
}
