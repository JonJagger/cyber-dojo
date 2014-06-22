
class Exercise

  def initialize(exercises,name,disk)
    @exercises,@name = exercises,name
    @disk = disk
  end

  attr_reader :name

  def path
    @exercises.path + name + '/'
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
