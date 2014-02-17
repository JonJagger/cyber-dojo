require 'DiskFile'

class Exercise
  
  #TODO: pass in cyberdojo object as 1st parameter  
  def initialize(root_dir, name)
    @root_dir = root_dir
    @name = name
    @file = Thread.current[:file] || DiskFile.new
  end

  def exists?
    @file.exists?(dir)
  end
  
  def dir
    @root_dir + @file.separator + 'exercises' + @file.separator + name
  end

  def name
    @name
  end
  
  def instructions
    @file.read(dir, 'instructions')
  end

end
