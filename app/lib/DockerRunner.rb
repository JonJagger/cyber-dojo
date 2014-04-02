
# runner that provides some isolation/protection/security.

class DockerRunner

  def run(paas, sandbox, command, max_seconds)
    language = sandbox.avatar.kata.language
    cmd = "docker run -u www-data --rm" +
          " -v #{paas.path(sandbox)}:/sandbox:rw" +
          " -v #{paas.path(language)}:#{paas.path(language)}:ro" +
          " -w /sandbox" +
          " #{language.image_name} /bin/bash -c \"#{with_stderr(command)}\""

    # timeout must go on 'docker run' command and not on
    # the command passed to docker run. This is to ensure
    # the docker run command does not start doing a docker pull
    # from the docker index which could easily take considerably
    # longer than the max_seconds limit.
    kill = 9
    output = `timeout --signal=#{kill} #{max_seconds}s #{cmd}`
    exit_status = $?.exitstatus
    fatal_error_signal = 128
    killed_by_timeout = fatal_error_signal + kill

    timed_out_message = "Terminated by the cyber-dojo server after #{max_seconds} seconds."
    exit_status != killed_by_timeout ? output : timed_out_message
  end

private

  def with_stderr(cmd)
    cmd + " " + "2>&1"
  end

end
