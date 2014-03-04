
module ExposedLinux

  class Exercises
    include Enumerable

    def initialize(paas,dojo)
      @paas,@dojo = paas,dojo
    end

    def each
      @paas.exercises_each(@dojo) do |name|
        yield self[name]
      end
    end

    def [](name)
      Exercise.new(@dojo,name)
    end

  end

end
