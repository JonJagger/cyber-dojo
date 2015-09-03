
class Exercise

  include ExternalParentChain
  
  def initialize(exercises,name,instructions=nil)
    @parent,@name,@instructions = exercises,name,instructions
  end

  attr_reader :name
  
  def path
    @parent.path + name + '/'
  end

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    @instructions || read(instructions_filename)
  end

private

  def instructions_filename
    'instructions'
  end

end
