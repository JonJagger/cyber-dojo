
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'
require_relative './../app_models/delta_maker'

class AppHelpersTestBase < TestBase

  def setup
    super
    set_runner_class('StubRunner')
  end

end
