# Runner that does nothing.

class TestRunnerDummy
  include TestRunner

  def runnable?(language)
    false
  end

  def run(sandbox, command, max_seconds)
    "dummy-test-runner\n" +
    "to use DockerTestRunner\n" +
    "$ export CYBERDOJO_RUNNER_CLASS_NAME=DockerTestRunner\n" +
    "to use HostTestRunner\n" +
    "$ export CYBERDOJO_RUNNER_CLASS_NAME=HostTestRunner"
  end

end