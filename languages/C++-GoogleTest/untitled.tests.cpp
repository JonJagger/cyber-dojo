#include "untitled.hpp"
#include "gtest/gtest.h"

using namespace ::testing;

TEST(UntitledTest, HitchHiker)
{
    ASSERT_EQ(6 * 9, hhg());
}