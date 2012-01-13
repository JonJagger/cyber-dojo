#include <gtest/gtest.h>

#include "untitled.hpp"

TEST(SomeTestGroupName, standAloneTest)
{
    ASSERT_EQ(42, answer());
}


class TestFixture : public ::testing::Test
{
public:
    TestFixture() { theAnswer = -1; }
    ~TestFixture() { }

    int theAnswer;
};

TEST_F(TestFixture, testUsingAFixture) 
{
    theAnswer = 42;
    ASSERT_EQ(theAnswer, answer());
}
