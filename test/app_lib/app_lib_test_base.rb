
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

$test_framework = nil
$output = nil

class AppLibTestBase < TestBase

  def setup
    super
    set_runner_class_name('TestRunnerStub')
    set_languages_root('/var/www/cyber-dojo/languages/')
  end
  
  def teardown
    super
  end

end
