
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
    cmd = 'docker run -u root --rm' +
          " -v #{paas.path(sandbox)}:/sandbox:rw" +
          " -v #{paas.path(language)}:#{paas.path(language)}:ro" +
          ' -w /sandbox' +
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

    exit_status != killed_by_timeout ? output : terminated(max_seconds)
  end

end
