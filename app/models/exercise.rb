
class Exercise

  def initialize(dojo,name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def instructions
    dojo.paas.disk_read(self,'instructions')
  end

end
