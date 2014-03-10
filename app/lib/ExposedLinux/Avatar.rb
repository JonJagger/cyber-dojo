
module ExposedLinux

  class Avatar
    extend Forwardable

    def self.names
        # no two animals start with the same letter
        %w(
            alligator buffalo cheetah deer
            elephant frog gorilla hippo
            koala lion moose panda
            raccoon snake wolf zebra
          )
    end

    def initialize(kata, name)
      @kata,@name = kata,name
    end

    attr_reader :kata, :name

    def_delegators :kata, :format, :format_is_rb?, :format_is_json?

    def sandbox
      Sandbox.new(self)
    end

    def save(delta, visible_files)
      kata.dojo.paas.save(self, delta, visible_files)
    end

    def test(max_duration = 15)
      kata.dojo.paas.test(self, max_duration)
    end

    def save_visible_files(visible_files)
      kata.dojo.paas.save_visible_files(self, visible_files)
    end

    def save_traffic_light(traffic_light, now = make_time(Time.now))
      kata.dojo.paas.save_traffic_light(self, traffic_light, now)
    end

    def visible_files(tag = nil)
      kata.dojo.paas.visible_files(self, tag)
    end

    def traffic_lights(tag = nil)
      kata.dojo.paas.traffic_lights(self, tag)
    end

    def diff_lines(was_tag, now_tag)
      kata.dojo.paas.diff_lines(self, was_tag, now_tag)
    end

    def commit(tag)
      kata.dojo.paas.commit(self, tag)
    end

    def traffic_lights_filename
      'increments.' + format
    end

    def visible_files_filename
      'manifest.' + format
    end

  private

    def make_time(now)
      [now.year, now.month, now.day, now.hour, now.min, now.sec]
    end

  end

end
