require 'Disk'

class Exercise
  
  def initialize(dojo, name)
    @disk = Thread.current[:disk] || Disk.new
    @dojo = dojo
    @name = name
  end

  def exists?
    @disk.exists?(dir)
  end
  
  def dir
    @dojo.dir + file_separator + 'exercises' + file_separator + name
  end

  def name
    @name
  end
  
  def instructions
    @disk.read(dir, 'instructions')
  end

private

  def file_separator
    @disk.file_separator
  end
  
end
