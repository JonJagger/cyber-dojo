
module ExposedLinux

  class Avatar

    def initialize(kata,name)
      @kata,@name = kata,name
    end

    def kata
      @kata
    end

    def name
      @name
    end

    def test(delta,visible_files)
      kata.dojo.paas.avatar_test(delta,visible_files)
    end

    def visible_files(tag)
      kata.dojo.paas.avatar_visible_files(tag)
    end

    def traffic_lights(tag)
      kata.dojo.paas.avatar_traffic_lights(tag)
    end

  end

end
