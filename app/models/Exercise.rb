
class Exercise

  def initialize(dojo,name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def path
    dojo.exercises.path + name + '/'
  end

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    dir.read(instructions_filename)
  end

private

  def dir
    dojo.paas.dir(self)
  end

  def instructions_filename
    'instructions'
  end

end
