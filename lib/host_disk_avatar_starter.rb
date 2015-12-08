
class HostDiskAvatarStarter

  def initialize(kata_path)
    @kata_path = kata_path
  end

  def start_avatar(avatar_names = Avatars.names.shuffle)
    # Relies on mkdir being atomic on a POSIX non NFS file system
    avatar_names.each do |avatar_name|
      _, exit_status = bash_exec("mkdir #{avatar_name} 2>&1")
      return avatar_name if exit_status == success
    end
    nil
  end

  def started_avatars
    lines,_ = bash_exec("ls -F | grep / | tr -d /")
    lines.split("\n") & Avatars.names
  end

  private

  def bash_exec(command)
    output = `cd #{@kata_path} && #{command}`
    return output, $?.exitstatus
  end

  def success
    0
  end

end
