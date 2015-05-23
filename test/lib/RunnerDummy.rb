# Runner that does nothing.

class RunnerDummy
  include Runner

  def runnable?(language)
    false
  end

  def run(sandbox, command, max_seconds)
    "dummy-test-runner\n" +
    "to use DockerRunner\n" +
    "$ export CYBERDOJO_RUNNER_CLASS_NAME=DockerRunner\n" +
    "to use HostRunner\n" +
    "$ export CYBERDOJO_RUNNER_CLASS_NAME=HostRunner"
  end

end