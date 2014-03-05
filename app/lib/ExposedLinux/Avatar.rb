
module ExposedLinux

  class Avatar

    def initialize(kata,name)
      @kata,@name = kata,name
    end

    attr_reader :kata, :name

    def test(delta,visible_files)
      kata.dojo.paas.avatar_test(self,delta,visible_files)
    end

    def visible_files(tag)
      kata.dojo.paas.avatar_visible_files(self,tag)
    end

    def traffic_lights(tag)
      kata.dojo.paas.avatar_traffic_lights(self,tag)
    end

  end

end
