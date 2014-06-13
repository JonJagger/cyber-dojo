require 'Externals'

class Exercise
  include Externals

  def initialize(dojo,name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def path
    dojo.exercises.path + name + '/'
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
