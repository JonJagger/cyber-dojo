
module TestAssertHelpers # mix-in

  module_function

  def assert_not_nil(o)
    assert !o.nil?
  end

  def assert_not_equal(lhs,rhs)
    assert lhs != rhs
  end

end
