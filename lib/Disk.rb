
class Disk

  def dir_separator
    File::SEPARATOR
  end

  def is_dir?(name)
    File.directory?(name) && !dot?(name)
  end

  def [](name)
    Dir.new(self, name)
  end

  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end

private

  def dot?(name)
    name === '.' || name === '..'
  end

end
