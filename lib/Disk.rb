require File.dirname(__FILE__) + '/dir'

class Disk

  def dir_separator
    File::SEPARATOR
  end

  def [](dir)
    Dir.new(self,dir)
  end

  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end

end
