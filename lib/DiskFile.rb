
require 'Files'

class DiskFile

  def write(dir, filename, object)
    Files::file_write(dir, filename, object)
  end
  
  def read(dir, filename)
    Files::file_read(dir, filename)
  end
  
end
