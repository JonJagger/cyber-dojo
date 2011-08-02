require File.dirname(__FILE__) + '/../test_helper'
require 'Ids'

# > ruby test/functional/id_generator_tests.rb

class IdGeneratorTests < ActionController::TestCase

  include Ids
    
  def test_generation
    prefix = "jj"
    g = IdGenerator.new(prefix)
    assert_equal prefix + "1", g.id
    assert_equal prefix + "2", g.id
  end
  
end

