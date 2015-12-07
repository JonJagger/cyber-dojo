
class HostDiskAvatarStarter

  def initialize(kata_path)
    @kata_path = kata_path
  end

  def start_avatar(avatar_names = Avatars.names.shuffle)
    # Relies on mkdir being atomic on Unix non NFS file system
    avatar_names.each do |avatar_name|
      _, exit_status = bash.exec("mkdir #{avtar_name}")
      return avatar_name if exit_status == success
    end
    nil
  end

  def started_avatars
    dirs = bash_exec('ls -d */').split # [ 'hippo/', 'lion/' ]
    dirs.map { |dir| dir[0..-2] }.select { |dir| Avatars.name.include? dir }
  end

  private

  def bash_exec(command)
    output = `cd #{@kata_path}; #{command}`
    return output, $?.exitstatus
  end

  def success
    0
  end

end
