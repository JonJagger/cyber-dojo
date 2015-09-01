#!/bin/bash

test_life_the_universe_and_everything()
{
  local expected=42
  local actual=$(answer)
  assertEquals ${expected} ${actual}
}

oneTimeSetUp()
{
  . ./hiker.inc
}

# load and run shUnit2
. shunit2
