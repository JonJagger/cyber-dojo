
module ExposedLinux

  class Exercise

    def initialize(dojo,name)
      @dojo,@name = dojo,name
    end

    attr_reader :dojo, :name

  end

end
