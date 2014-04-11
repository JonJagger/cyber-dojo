
# runner providing some isolation/protection/security

class DockerRunner

  def runnable?(language)
    @installed ||= `docker images`.lines.each.collect{|line| line.split[0]}
    @installed.include?(language.image_name)
  end

  def run(paas, sandbox, command, max_seconds)
    inner_command = "timeout --signal=#{kill} #{max_seconds}s #{stderr2stdout(command)}"
    language = sandbox.avatar.kata.language
    outer_command =
      "docker run" +
        " -u root" +
        " --rm" +
        " -v #{paas.path(sandbox)}:/sandbox:#{read_write}" +
        " -v #{paas.path(language)}:#{paas.path(language)}:#{read_only}" +
        " -w /sandbox" +
        " #{language.image_name} /bin/bash -c \"#{inner_command}\""

    output = `#{outer_command}`
    $?.exitstatus != fatal_error(kill) ? output : terminated_after(max_seconds)
  end

private

  def stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

  def terminated_after(max_seconds)
    "Terminated by the cyber-dojo server after #{max_seconds} seconds."
  end

  def read_write
    'rw'
  end

  def read_only
    'ro'
  end

end
