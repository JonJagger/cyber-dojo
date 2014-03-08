
module ExposedLinux

  class Kata

    def initialize(dojo,id)
      @dojo,@id = dojo,id
    end

    attr_reader :dojo, :id

    def language
      dojo.languages[manifest['language']]
    end

    def exercise
      dojo.exercises[manifest['exercise']]
    end

    def start_avatar
      dojo.paas.start_avatar(self)
    end

    def avatars
      Avatars.new(self)
    end

    def visible_files
      manifest['visible_files']
    end

    def manifest_filename
      'manifest.' + format
    end

    def manifest
      text = read(manifest_filename)
      if format == 'rb'
        return @manifest ||= JSON.parse(JSON.unparse(eval(text)))
      end
      if format == 'json'
        return @manifest ||= JSON.parse(text)
      end
    end

  private

    def format
      dojo.format
    end

    def read(filename)
      dojo.paas.kata_read(self,filename)
    end

  end

end
