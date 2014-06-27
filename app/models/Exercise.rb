
class Exercise

  def initialize(path,name,disk)
    @path,@name = path,name
    @disk = disk
  end

  attr_reader :name

  def path
    @path + name + '/'
  end

  def dir
    @disk[path]
  end

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    dir.read(instructions_filename)
  end

  def instructions_filename
    'instructions'
  end

end
