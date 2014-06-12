
class Katas
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def path
    dojo.path + 'katas/'
  end

  def each
    # dojo.katas.each
    paas.katas_each(self) do |id|
      yield self[id]
    end
  end

  def [](id)
    # dojo.katas[id]
    Kata.new(dojo,id)
  end

private

  def paas
    dojo.paas
  end

end
