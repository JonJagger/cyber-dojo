
module ExposedLinux

  class Dojo

    def initialize(paas,root_dir,format)
      @paas,@root_dir,@format = paas,root_dir,format
    end

    def languages
      Languages.new(@paas,self)
    end

    def exercises
      Exercises.new(@paas,self)
    end

    def make_kata(language,exercise)
      @paas.make_kata(language,exercise)
    end
  end

end

