
gem 'minitest'
require 'minitest/autorun'

require_relative './TestDomainHelpers'
require_relative './TestExternalHelpers'
require_relative './TestHexIdHelpers'

class TestBase < MiniTest::Test
  
  include TestDomainHelpers
  include TestExternalHelpers
  include TestHexIdHelpers

end
