#include "untitled.hpp"
#include "untitled_helper.hpp"

Untitled::Untitled(UntitledHelper const & _helper)
    : helper(_helper)
{
}

int Untitled::answer()
{
    return helper.answer();
}

