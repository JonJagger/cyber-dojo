
# runner that provides some isolation/protection/security.

require 'Runner'
require 'timeout'

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

    pipe = nil
    begin
      pipe = IO::popen(cmd, 'r')
    rescue Exception => e
      Rails.logger.warn "Execution of command #{cmd} unsuccessful"
    end

    output = ''
    begin
      status = Timeout::timeout(max_seconds) {
        Process.waitpid2(pipe.pid)
        output = pipe.gets(nil)
      }
    rescue Timeout::Error
      Process.kill('-KILL', pipe.pid)
      output = terminated(max_seconds)
    end
    pipe.close
    output


=begin
    kill = 9
    pid = Process.spawn(cmd)
    begin
      Timeout.timeout(max_seconds) do
        Process.wait(pid)
      end
    rescue TimeoutError
      Process.kill("-#{kill}", pid)
    end


    output = `timeout --signal=#{kill} --kill-after=1 #{max_seconds}s #{cmd}`
    exit_status = $?.exitstatus
    # kill process and all children
    msg = `kill -TERM -#{$?.pid}`
    fatal_error_signal = 128
    killed_by_timeout = fatal_error_signal + kill

    exit_status != killed_by_timeout ? output : terminated(max_seconds)
=end
  end

end
