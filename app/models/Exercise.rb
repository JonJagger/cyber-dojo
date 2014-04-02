
class Exercise

  def initialize(dojo,name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def instructions
    paas.read(self,'instructions')
  end

private

  def paas
    dojo.paas
  end

end
