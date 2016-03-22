
require_relative '../all'

class AppHelpersTestBase < TestBase

  def setup
    super
    set_runner_class('StubRunner')
  end

end
