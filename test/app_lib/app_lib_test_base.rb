
require_relative '../test_coverage'
require_relative '../all'
require 'test/unit'

class AppLibTestBase < Test::Unit::TestCase

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

end
