
# runner that provides some isolation/protection/security.

require 'Runner'

class DockerRunner
  include Runner

  def runnable?(language)
    @installed ||= `docker images`.lines.each.collect{|line| line.split[0]}
    @installed.include?(language.image_name)
  end

  def run(paas, sandbox, command, max_seconds)
    language = sandbox.avatar.kata.language
    inner_cmd = "timeout --signal=#{kill} #{max_seconds}s #{with_stderr(command)}"

    outer_cmd = 'docker run -u root --rm' +
          " -v #{paas.path(sandbox)}:/sandbox:rw" +
          " -v #{paas.path(language)}:#{paas.path(language)}:ro" +
          ' -w /sandbox' +
          " #{language.image_name} /bin/bash -c \"#{inner_cmd}\""

    output = `#{outer_cmd}`
    $?.exitstatus != fatal_error(kill) ? output : terminated(max_seconds)
  end

private

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

end
