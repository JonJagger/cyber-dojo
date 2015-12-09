
class HostDiskAvatarStarter

  def initialize(dojo)
    @dojo = dojo
  end

  # queries

  def parent
    @dojo
  end

  def started_avatars(path)
    lines = output_of(shell.cd_exec(path, 'ls -F | grep / | tr -d /'))
    lines.split("\n") & Avatars.names
  end

  # modifiers

  def start_avatar(path, avatar_names = Avatars.names.shuffle)
    # Relies on mkdir being atomic on a POSIX non NFS file system
    avatar_names.each do |avatar_name|
      _, exit_status = shell.cd_exec(path, "mkdir #{avatar_name} #{stderr_2_stdout}")
      return avatar_name if exit_status == shell.success
    end
    nil
  end

  private

  include ExternalParentChainer

  def output_of(args)
    args[0]
  end

  def stderr_2_stdout
    '2>&1'
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Starting an avatar needs to be atomic otherwise two
# laptops in a cyber-dojo could start as the same animal.
#
#   app/models/kata.rb    start_avatar()
#   app/models/avatars.rb started_avatars()
#
# On a non NFS POSIX file system I do this relying on
# mkdir being atomic. When cyber-dojo has horizontal
# scaling this won't work and I'll need to use something
# like Google's networked object store.
# https://cloud.google.com/storage/docs/json_api/v1/objects/update
# This has an api allowing optimistic locking.
# - - - - - - - - - - - - - - - - - - - - - - - - - - -
