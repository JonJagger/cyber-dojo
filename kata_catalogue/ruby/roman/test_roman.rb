require 'roman'
require 'test/unit'

class TestRoman < Test::Unit::TestCase

  def test_simple
    assert_equal("i", Roman.new(1).to_s)
  end

end

