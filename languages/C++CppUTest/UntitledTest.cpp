#include "Untitled.h"

//CppUTest includes should be after your and system includes
#include "CppUTest/TestHarness.h"

TEST_GROUP(Untitled)
{
    Untitled* untitled;

    void setup()
    {
        untitled = new Untitled();
    }
    void teardown()
    {
        delete untitled;
    }
};

TEST(Untitled, Create)
{
    LONGS_EQUAL(42, 42);
    CHECK(1);
    CHECK_TRUE(1);
    CHECK_FALSE(0);
    STRCMP_EQUAL("hey", "hey");
//    FAIL("Start here");
}

