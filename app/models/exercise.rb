
class Exercise

  def initialize(dojo,name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def instructions
    dojo.paas.read(self,'instructions')
  end

end
