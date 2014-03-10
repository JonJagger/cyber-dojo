
module ExposedLinux

  class Kata
    extend Forwardable

    def initialize(dojo, id)
      @dojo,@id = dojo,id
    end

    attr_reader :dojo, :id

    def_delegators :dojo, :format, :format_is_rb?, :format_is_json?

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
      'manifest.' + dojo.format
    end

    def manifest
      text = read(manifest_filename)
      return @manifest ||= JSON.parse(JSON.unparse(eval(text))) if format_is_rb?
      return @manifest ||= JSON.parse(text) if format_is_json?
    end

  private

    def read(filename)
      dojo.paas.read(self, filename)
    end

  end

end
