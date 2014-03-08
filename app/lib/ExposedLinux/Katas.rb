
module ExposedLinux

  class Katas
    include Enumerable

    def initialize(dojo)
      @dojo = dojo
    end

    attr_reader :dojo

    def each
      dojo.paas.katas_each(self) do |id|
        yield self[id]
      end
    end

    def [](id)
      Kata.new(dojo,id)
    end

  end

end
