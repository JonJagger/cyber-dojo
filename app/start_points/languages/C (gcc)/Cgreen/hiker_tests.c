#include <cgreen/cgreen.h>

#include "hiker.h"


Describe(hiker);
BeforeEach(hiker) {}
AfterEach(hiker) {}

Ensure(hiker, answers_42) {
    assert_that(answer(), is_equal_to(42));
}
