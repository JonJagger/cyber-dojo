
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
    # -----------------------------------------------------------------------------
    # $$$$$$$$$$$$$$$$$$$$$$$$$$$$ NOTE WELL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    # $$$$$$$$$$$$$$$$$$$$$$$$$$$$ NOTE WELL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    # $$$$$$$$$$$$$$$$$$$$$$$$$$$$ NOTE WELL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    # -----------------------------------------------------------------------------
    # The line
    #    output = capture_stdout { system(command) }
    # cannot be replaced with
    #    output = `#{command}`
    #
    # With backticks, lib/docker_tmp_runner.sh (called from lib/docker_tmp_runner.rb)
    # sleeps for its *FULL* timeout even if cyber-dojo.sh completes almost instantly?!
    # Using system() does not have this problem!
    # But system does not return the output.
    # Hence the capture_stdout wrapper.
    # -----------------------------------------------------------------------------
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
