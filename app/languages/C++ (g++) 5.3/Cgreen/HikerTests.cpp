#include <cgreen/cgreen.h>

#include "Hiker.hpp"

using namespace cgreen;

Describe(Hiker);
BeforeEach(Hiker) {}
AfterEach(Hiker) {}

Ensure(Hiker, answers_42) {
    Hiker hiker;
    assert_that(hiker.answer(), is_equal_to(42));
}
