
gem "minitest"
require 'minitest/autorun'

require_relative './TestAssertHelpers'
require_relative './TestDomainHelpers'
require_relative './TestExternalHelpers'

class TestBase < MiniTest::Test
  
  include TestAssertHelpers
  include TestDomainHelpers
  include TestExternalHelpers

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end
    
end