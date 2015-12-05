
class HostDiskAvatarStarter

  # NB: start_avatar() and started_avatars() must not
  # call each other because fd.flock is not recursive

  # Old dojos didn't use a 'started_avatars.json' file.
  # Retro-fit them so they do.

  def start_avatar(kata, avatar_names = Avatars.names.shuffle)
    avatar = nil
    HostFileLocker.lock(lock_file(kata.path)) do
      dir = kata.disk[kata.path]
      started = dir.exists?(filename) ? dir.read_json(filename) : started_avatars_names(kata)
      unstarted = avatar_names - started
      if unstarted != []
        avatar = Avatar.new(kata, unstarted[0])
        dir.write_json(filename, started << avatar.name)
      end
    end
    avatar
  end

  def started_avatars(kata)
    names = []
    HostFileLocker.lock(lock_file(kata.path)) do
      dir = kata.disk[kata.path]
      if dir.exists?(filename)
        names = dir.read_json(filename)
      else
        dir.write_json(filename, names = avatars_names)
      end
    end
    Hash[names.map{ |name| [name, Avatar.new(kata, name)]}]
  end

  private

  def lock_file(path)
    path + 'f.lock'
  end

  def filename
    'started_avatars.json'
  end

  def started_avatars_names(kata)
    names = []
    Avatars.names.each do |name|
      names << name if kata.disk[Avatar.new(kata, name).path].exists?
    end
    names
  end

end
