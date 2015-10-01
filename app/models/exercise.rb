
class Exercise

  def initialize(exercises, name, instructions = nil)
    @parent = exercises
    @name = name
    @instructions = instructions
  end

  attr_reader :name

  def path
    @parent.path + name + '/'
  end

  def instructions
    @instructions || read(instructions_filename)
  end

  private

  include ExternalParentChain

  def instructions_filename
    'instructions'
  end

end
