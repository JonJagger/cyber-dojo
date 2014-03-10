
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

    def make_kata(language, exercise, id = Uuid.new.to_s, now = make_time(Time.now))
      kata = Kata.new(language.dojo, id)
      paas.disk_make_dir(kata)
      manifest = {
        :created => now,
        :id => id,
        :language => language.name,
        :exercise => exercise.name,
        :unit_test_framework => language.unit_test_framework,
        :tab_size => language.tab_size
      }
      manifest[:visible_files] = language.visible_files
      manifest[:visible_files]['output'] = ''
      manifest[:visible_files]['instructions'] = exercise.instructions
      paas.disk_write(kata, kata.manifest_filename, manifest)
      kata
    end

    def katas
      Katas.new(self)
    end

  private

    def make_time(now)
      [now.year, now.month, now.day, now.hour, now.min, now.sec]
    end

  end

end
