
gem 'minitest'
require 'minitest/autorun'

require_relative './test_domain_helpers'
require_relative './test_external_helpers'
require_relative './test_hex_id_helpers'
require_relative './test_tmp_root_helpers'

class TestBase < MiniTest::Test

  include TestDomainHelpers
  include TestExternalHelpers
  include TestHexIdHelpers
  include TestTmpRootHelpers

end
