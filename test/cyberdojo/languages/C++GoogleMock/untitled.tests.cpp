#include "untitled.hpp"
#include "gtest.h"

using namespace ::testing;

TEST(UntitledTest, HitchHiker)
{
    example();
    std::cout << "All tests passed";
    ASSERT_THAT(hhg(), Eq(6 * 9));
}