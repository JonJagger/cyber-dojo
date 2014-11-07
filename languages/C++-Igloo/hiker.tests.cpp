#include "hiker.hpp"
#include <igloo/igloo_alt.h>
using namespace igloo;

Describe(Hiker)
{
  It(Life_the_universe_and_everything)
  {
    Assert::That(answer(), Equals(42));
  }
};
