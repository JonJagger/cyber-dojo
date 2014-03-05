
module ExposedLinux

  class Language

    def initialize(dojo,name)
      @dojo,@name = dojo,name
    end

    attr_reader :dojo, :name

  end

end
