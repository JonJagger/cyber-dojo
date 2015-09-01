#include "hiker.hpp"
#include <cassert>
#include <iostream>

namespace {
 
void life_the_universe_and_everthing()
{
    assert(answer() == 42);
}

} // namespace

int main()
{
    life_the_universe_and_everthing();
    // green-traffic light pattern...    
    std::cout << "All tests passed";
}
