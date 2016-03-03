
class Exercise

  def initialize(exercises, name, instructions = nil)
    @exercises = exercises
    @name = name
    @instructions = instructions
  end

  # queries

  attr_reader :exercises, :name

  def parent
    exercises
  end

  def path
    parent.path + '/' + name
  end

  def instructions
    @instructions || disk[path].read(instructions_filename)
  end

  private

  include ExternalParentChainer

  def instructions_filename
    'instructions'
  end

end
