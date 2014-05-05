
class Exercise

  def initialize(dojo,name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def exists?
    paas.exists?(self, instructions_filename)
  end

  def instructions
    paas.read(self, instructions_filename)
  end

private

  def paas
    dojo.paas
  end

  def instructions_filename
    'instructions'
  end

end
