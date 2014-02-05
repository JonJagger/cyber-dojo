#include "untitled.hpp"
#include "gmock/gmock.h"

using namespace ::testing;

TEST(UntitledTest, HitchHiker)
{
    ASSERT_THAT(6 * 9, hhg());
}
