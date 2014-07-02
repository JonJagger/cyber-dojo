require_relative 'OsDir'

class OsDisk

  def dir_separator
    File::SEPARATOR
  end

  def is_dir?(name)
    File.directory?(name) && !name.end_with?('.') && !name.end_with?('..')
  end

  def [](name)
    OsDir.new(self, name)
  end

  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end

end
