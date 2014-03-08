
module ExposedLinux

  class Avatar

    def self.names
        # no two animals start with the same letter
        %w(
            alligator buffalo cheetah deer
            elephant frog gorilla hippo
            koala lion moose panda
            raccoon snake wolf zebra
          )
    end

    def initialize(kata,name)
      @kata,@name = kata,name
    end

    attr_reader :kata, :name

    def save_traffic_light(traffic_light,now)
      kata.dojo.paas.save_traffic_light(self,traffic_light,now)
    end

    def save(delta,visible_files)
      kata.dojo.paas.save(self,delta,visible_files)
    end

    def test()
      kata.dojo.paas.test(self)
    end

    def visible_files(tag)
      kata.dojo.paas.visible_files(self,tag)
    end

    def traffic_lights(tag)
      kata.dojo.paas.traffic_lights(self,tag)
    end

    def diff_lines(was_tag,now_tag)
      kata.dojo.paas.diff_lines(self,was_tag,now_tag)
    end

    def commit(tag)
      kata.dojo.paas.commit(self,tag)
    end

    def traffic_lights_filename
      'increments.' + format
    end

    def visible_files_filename
      'manifest.' + format
    end

  private

    def format
      kata.dojo.format
    end

  end

end
