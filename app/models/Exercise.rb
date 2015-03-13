
class Exercise

  def initialize(exercises,name)
    @exercises,@name = exercises,name
  end

  attr_reader :name
  
  def path
    @exercises.path + name + '/'
  end

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    dir.read(instructions_filename)
  end

private

  include ExternalDiskDir

  def instructions_filename
    'instructions'
  end

end
