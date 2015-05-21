
class Disk

  def initialize(dojo=nil)
  end
    
  def dir_separator
    File::SEPARATOR
  end

  def dir?(name)
    File.directory?(name)
  end

  def [](name)
    Dir.new(self, name)
  end

  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end

end
