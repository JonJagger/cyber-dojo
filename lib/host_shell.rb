
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
    output = `#{command}`
    exit_status = $?.exitstatus
    log << output if output != ''
    log << "$?.exitstatus=#{exit_status}" if exit_status != success
    return cleaned(output), exit_status
  end

  private

  include ExternalParentChainer
  include StringCleaner

end
