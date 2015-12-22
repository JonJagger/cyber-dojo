
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppHelpersTestBase < TestBase

  def setup
    super
    set_runner_class('RunnerMock')
  end

end
