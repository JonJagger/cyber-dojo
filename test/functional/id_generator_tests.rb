require 'test_helper'

class DomIdGeneratorTests < ActionController::TestCase
  
  def test_generation
    prefix = "jj"
    g = IdGenerator.new(prefix)
    assert_equal prefix + "1", g.id
    assert_equal prefix + "2", g.id
  end
  
end

