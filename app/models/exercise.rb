require 'DiskFile'

class Exercise
  
  def initialize(root_dir, name)
    @root_dir = root_dir
    @name = name
    @file = Thread.current[:file] || DiskFile.new
  end

  def dir
    @root_dir + File::SEPARATOR + 'exercises' + File::SEPARATOR + name
  end

  def name
    @name
  end
  
  def instructions
    @file.read(dir, 'instructions')
  end

end
