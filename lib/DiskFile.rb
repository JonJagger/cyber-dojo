
require 'Files'

class DiskFile

  def separator
    File::SEPARATOR
  end
  
  def write(dir, filename, object)
    #TODO: move the implementation of Files::file_write to here
    Files::file_write(dir, filename, object)
  end
  
  def read(dir, filename)
    Files::file_read(dir, filename)
  end
  
  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end
  
  def directory?(dir)
    File.directory?(dir)
  end
  
  def exists?(dir, filename)
    File.exists?(dir + separator + filename)
  end
  
end
