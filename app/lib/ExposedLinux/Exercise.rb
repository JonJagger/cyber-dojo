
module ExposedLinux

  class Exercise

    def initialize(dojo,name)
      @dojo,@name = dojo,name
    end

    attr_reader :dojo, :name

    def instructions
      dojo.paas.exercise_read(self,'instructions')
    end

  end

end
