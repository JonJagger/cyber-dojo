
require_relative '../test_coverage'
require_relative '../all'
require 'test/unit'

class AppHelpersTestBase < Test::Unit::TestCase

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  def thread
    Thread.current
  end

end
