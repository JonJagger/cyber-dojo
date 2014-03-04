
module ExposedLinux

  class Dojo

    def initialize(paas,root_dir,format)
      @paas,@root_dir,@format = paas,root_dir,format
    end

    def paas
      @paas
    end

    def languages
      Languages.new(self)
    end

    def exercises
      Exercises.new(self)
    end

  end

end

