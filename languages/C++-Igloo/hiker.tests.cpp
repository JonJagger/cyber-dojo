#include "hiker.hpp"
#include <igloo/igloo.h>
using namespace igloo;

Context(Hiker)
{
  Spec(Life_the_universe_and_everything)
  {
    Assert::That(answer(), Equals(42));
  }
};
