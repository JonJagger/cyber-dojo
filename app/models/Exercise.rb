
class Exercise
  include ExternalParentChain
  
  def initialize(exercises,name)
    @parent,@name = exercises,name
  end

  attr_reader :name
  
  def path
    @parent.path + name + '/'
  end

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    dir.read(instructions_filename)
  end

private

  def instructions_filename
    'instructions'
  end

end
