
# Runner that does nothing.

require_relative 'TestRunner'

class StubTestRunner
   include TestRunner

  def runnable?(language)
    true
  end

  def run(sandbox, command, max_seconds)
    "stub-test-runner"
  end

end