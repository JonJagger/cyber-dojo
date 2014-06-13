require 'Externals'

class Exercise
  include Externals

  def initialize(exercises,name)
    @exercises,@name = exercises,name
  end

  attr_reader :exercises, :name

  def path
    exercises.path + name + '/'
  end

  def exists?
    dir(path).exists?(instructions_filename)
  end

  def instructions
    dir(path).read(instructions_filename)
  end

  def instructions_filename
    'instructions'
  end

end
