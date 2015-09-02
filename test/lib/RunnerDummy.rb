# Runner that does nothing.

class RunnerDummy
  include Runner

  def runnable?(language)
    false
  end

  def run(sandbox, command, max_seconds)
    "dummy-test-runner\n" +
    "to use DockerVolumeMountRunner\n" +
    "$ export CYBER_DOJO_RUNNER_CLASS_NAME=DockerVolumeMountRunner\n" +
    "to use HostRunner\n" +
    "$ export CYBER_DOJO_RUNNER_CLASS_NAME=HostRunner"
  end

  def started(avatar); end

end