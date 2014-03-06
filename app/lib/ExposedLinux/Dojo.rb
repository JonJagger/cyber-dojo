
module ExposedLinux

  class Dojo

    def initialize(paas,root,format)
      @paas,@root,@format = paas,root,format
    end

    attr_reader :paas, :root, :format

    def languages
      Languages.new(self)
    end

    def exercises
      Exercises.new(self)
    end

    def make_kata(language,exercise)
      paas.make_kata(language,exercise)
    end

    def katas
      Katas.new(self)
    end

  end

end
