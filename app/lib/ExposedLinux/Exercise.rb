
module ExposedLinux

  class Exercise

    def initialize(dojo,name)
      @dojo,@name = dojo,name
    end

    attr_reader :dojo, :name

    def instructions
      dir.read('instructions')
    end

    def path
      Exercises.new(dojo).path + name + '/'
    end

  private
  
    def dir
      dojo.paas.disk[path]
    end

  end

end
