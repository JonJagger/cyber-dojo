
class HostDiskAvatarStarter

  # NB: start_avatar() and started_avatars() must not
  # call each other because fd.flock is not recursive

  def start_avatar(kata, avatar_names = Avatars.names.shuffle)
    dir = kata.disk[kata.path]
    avatar = nil
    lock(kata_path) do
      started = dir.exists?(filename) ? dir.read_json(filename) : started_avatars_names(kata)
      free_names = avatar_names - started
      if free_names != []
        avatar = Avatar.new(kata, free_names[0])
        dir.write_json(filename, started << avatar.name)
      end
    end
    avatar
  end

  def started_avatars(kata)
    dir = kata.disk[kata.path]
    names = []
    lock(kata_path) do
      if dir.exists?(filename)
        names = dir.read_json(filename)
      else
        dir.write_json(filename, names = avatars_names)
      end
    end
    Hash[names.map{ |name| [name, Avatar.new(kata.path, name)]}]
  end

  private

  def filename
    'started_avatars.json'
  end

  def lock(kata_path, &block)
    result = nil
    File.open(kata_path + 'f.lock', 'w') do |fd|
      if fd.flock(File::LOCK_EX)
        begin
          result = block.call
        ensure
          fd.flock(File::LOCK_UN)
        end
      end
    end
    result
  end

  def started_avatars_names(kata)
    names = []
    Avatars.names.each do |name|
      names << name if Avatar.new(kata, name).exists?
    end
    names
  end

end
