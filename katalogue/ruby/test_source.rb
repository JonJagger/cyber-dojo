require 'source'
require 'test/unit'

class TestSource < Test::Unit::TestCase

  def test_simple
    assert_equal("abc", Source.new().to_s)
  end

end

