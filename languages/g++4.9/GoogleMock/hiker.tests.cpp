#include "hiker.hpp"
#include <gmock/gmock.h>

using namespace ::testing;

namespace {

TEST(Hiker, Life_the_universe_and_everything)
{
    ASSERT_THAT(answer(), Eq(42));
}

}