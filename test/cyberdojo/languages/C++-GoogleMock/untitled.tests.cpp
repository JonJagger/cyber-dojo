#include "untitled.hpp"
#include "gmock/gmock.h"

using namespace ::testing;

class UntitledHelperMock : public UntitledHelper {
public:
    MOCK_CONST_METHOD0(answer, int());
};

TEST(UntitledTest, HitchHiker)
{
    UntitledHelperMock helper;
    Untitled target(helper);

    EXPECT_CALL(helper, answer()).Return(24);

    ASSERT_THAT(target.answer(), Eq(6 * 9));
}
