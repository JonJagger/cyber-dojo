
require_relative './TestHelpers'

class TestBase < MiniTest::Test
  
  include TestHelpers
  
  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end
    
end