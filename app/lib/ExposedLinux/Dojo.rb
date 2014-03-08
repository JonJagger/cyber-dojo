
module ExposedLinux

  class Dojo

    def initialize(paas, path, format)
      @paas,@path,@format = paas,path,format
      raise RuntimeError.new("path must end in /") if !path.end_with?('/')
    end

    attr_reader :paas, :path, :format

    def format_is_rb?
      format == 'rb'
    end

    def format_is_json?
      format == 'json'
    end

    def languages
      Languages.new(self)
    end

    def exercises
      Exercises.new(self)
    end

    def make_kata(language, exercise)
      paas.make_kata(language, exercise)
    end

    def katas
      Katas.new(self)
    end

  end

end
