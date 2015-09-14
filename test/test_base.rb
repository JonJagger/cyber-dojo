
gem 'minitest'
require 'minitest/autorun'

require_relative './TestDomainHelpers'
require_relative './TestExternalHelpers'
require_relative './TestWithId'

class TestBase < MiniTest::Test
  
  include TestDomainHelpers
  include TestExternalHelpers

  def self.id
    @@tests ||= TestWithId.new(self)
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

end
