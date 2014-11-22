
# Runner that does nothing.

require_relative 'TestRunner'

class DummyTestRunner
   include TestRunner

  def runnable?(language)
    false
  end

  def run(sandbox, command, max_seconds)
    "dummy-test-runner\n" +
    "to use HostTestRunner\n" +
    "$ export CYBERDOJO_USE_HOST=true"
  end

end