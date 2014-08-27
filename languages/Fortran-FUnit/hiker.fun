test_suite hiker

setup
end setup

teardown
end teardown

test life_the_universe_and_everything
  integer :: actual
  actual = answer()
  assert_equal(42, actual)
end test

! Example test using all six assertions
test funit_assertions
  integer, dimension(2) :: a = (/ 1, 2 /)
  integer, dimension(2) :: b = (/ 1, 2 /)

  assert_array_equal(a,b)
  assert_real_equal(0.9999999e0, 1.0e0)
  assert_equal_within(1e-7, 0.0, 1e-6)
  assert_equal(1, 5 - 4)
  assert_false(5 < 4)
  assert_true(4 == 4)
end test

end test_suite
