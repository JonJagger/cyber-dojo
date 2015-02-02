
class Exercise

  def initialize(path,name)
    @path,@name = path,name
  end

  attr_reader :name

  def exists?
    dir.exists?(instructions_filename)
  end

  def instructions
    dir.read(instructions_filename)
  end

  def path
    @path + name + '/'
  end

private

  include ExternalGetter

  def instructions_filename
    'instructions'
  end

end
