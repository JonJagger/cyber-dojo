require 'minitest/autorun'

class TestBase < MiniTest::Test

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  def assert_not_nil(o)
    assert !o.nil?
  end

  def assert_not_equal(lhs,rhs)
    assert lhs != rhs
  end

end