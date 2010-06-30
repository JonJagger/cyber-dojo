require 'untitled'
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  def test_simple
    assert_equal "abc", Untitled.new().to_s
  end

end

