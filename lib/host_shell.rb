
require 'tempfile'

class HostShell

  def initialize(dojo)
    @dojo = dojo
  end

  # queries

  def parent
    @dojo
  end

  def success
    0
  end

  # modifiers

  def cd_exec(path, *commands)
    # @docker_tmp_runner = commands[0].start_with?('./docker_tmp_runner.sh')
    output, exit_status = exec(["cd #{path}"] + commands)
    return output, exit_status
  end

  def daemon_exec(*commands)
    command = commands.join(' && ')
    log << command
    fork do
      Process.daemon
      Process.exec(command)
    end
  end

  def exec(*commands)
    command = commands.join(' && ')
    log << command
    # NOTE WELL: The line
    #    output = capture_stdout { system(command) }
    # cannot be replaced with
    #    output = `#{command}`
    #
    # With backticks, lib/docker_tmp_runner.sh (called from lib/docker_tmp_runner.rb)
    # sleeps for its full timeout even if cyber-dojo.sh completes almost instantly.
    # Using system() does not have this problem. But system does not return the output.
    # Hence the capture_stdout wrapper.
    #
    # If the web container is based off Alpine, whether you use backticks or system,
    # a zombie/orphan processes is left behind for each call to lib/docker_tmp_runner.sh
    # https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
    #
    # What happens (ps inside the web container) is
    #
    # PID  USER  TIME   COMMAND
    # 52   root  0:00   {docker_tmp_runn} /bin/sh ./docker_tmp_runner.sh
    #                                                 /tmp/cyber-dojo-BB2DE4C307/
    #                                                 cyberdojofoundation/gcc_assert
    #                                                 10
    # 56   root  0:00    sleep 10
    #
    # and a bit later the [sleep] is gone but {docker_tmp_runner} is still there
    #
    # PID  USER  TIME   COMMAND
    # 52   root  0:00   [docker_tmp_runn]
    #
    # I've run this with backticks for all calls except docker_tmp_runner.sh
    # (using @docker_tmp_runner) and using system() for the docker_tmp_runner.sh
    # call and not done the capture_stdout and you still get the zombie/orphan.
    #
    # I've removed this line from docker_tmp_runner.sh
    #     (sleep $MAX_SECONDS && docker rm --force $CID &> /dev/null) &
    # and you don't get the zombie/orphan.
    #
    # So I come to the conlusion that I can't base the web image off Alpine.
    # Trying debian:jessie

    output = capture_stdout { system(command) }

    exit_status = $?.exitstatus
    log << output if output != ''
    log << "$?.exitstatus=#{exit_status}" if exit_status != success
    return cleaned(output), exit_status
  end

  private

  include ExternalParentChainer
  include StringCleaner

  # http://www.thecodingforums.com/threads/redirect-stdout-for-kernel-system.812652/
  def capture_stdout
    stdout = $stdout.dup
    Tempfile.open 'stdout-redirect' do |temp|
      $stdout.reopen temp.path, 'w+'
      yield if block_given?
      $stdout.reopen stdout
      temp.read
    end
  end

end
