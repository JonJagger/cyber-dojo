#include "untitled.hpp"
#include "gtest.h"
#include "gmock.h"

using namespace ::testing;

TEST(UntitledTest, HitchHiker)
{
  ASSERT_THAT(hhg(), Eq(6 * 9));
}

