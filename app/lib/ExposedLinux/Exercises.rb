
module ExposedLinux

  class Exercises
    include Enumerable

    def initialize(dojo)
      @dojo = dojo
    end

    def each
      @dojo.paas.exercises_each {|name| yield Exercise.new(name) }
    end

  end

end
