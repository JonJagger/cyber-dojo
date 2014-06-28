
__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_coverage'
require __DIR__ + '/../all'

require 'test/unit'

class LibTestBase < Test::Unit::TestCase

  def self.test(name, &block)
      define_method("test_#{name}".to_sym, &block)
  end

end
