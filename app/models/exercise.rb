require 'DiskFile'

class Exercise
  
  def initialize(dojo, name)
    @file = Thread.current[:disk] || DiskFile.new
    @dojo = dojo
    @name = name
  end

  def exists?
    @file.exists?(dir)
  end
  
  def dir
    @dojo.dir + @file.separator + 'exercises' + @file.separator + name
  end

  def name
    @name
  end
  
  def instructions
    @file.read(dir, 'instructions')
  end

end
