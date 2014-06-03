
# Designed to allow...
#
# o) dojo.katas[id] to access a specific kata
# o) dojo.katas.each to iterate through a dojo's katas

class Katas
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    paas.katas_each(self) do |id|
      yield self[id]
    end
  end

  def [](id)
    Kata.new(dojo,id)
  end

private

  def paas
    dojo.paas
  end

end
