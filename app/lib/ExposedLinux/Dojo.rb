
module ExposedLinux

  class Dojo

    def initialize(paas,root_path,format)
      @paas,@root_path,@format = paas,root_path,format
    end

    def paas
      @paas
    end

    def root_path
      @root_path
    end

    def format
      @format
    end
    
    def languages
      Languages.new(self)
    end

    def exercises
      Exercises.new(self)
    end

    def make_kata(language,exercise)
      @paas.make_kata(language,exercise)
    end

    def katas
      Katas.new(self)
    end

  end

end
