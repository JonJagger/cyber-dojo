#include "CppUTest/TestHarness.h"

extern "C"
{
#include "untitled.h"
}

TEST_GROUP(TheGroupName)
{
    void setup()
    {
    }

    void teardown()
    {
    }
};

TEST(TheGroupName, a_meaningful_test_name)
{
    // a simple example to start you off
    LONGS_EQUAL(42, the_answer_is());
    //CHECK(1);
    //CHECK_TRUE(1);
    //CHECK_FALSE(0);
    //STRCMP_EQUAL("hey", "hey");
    //FAIL("Start here");
}
