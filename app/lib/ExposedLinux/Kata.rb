
module ExposedLinux

  class Kata

    def initialize(dojo,id)
      @dojo,@id = dojo,id
    end

    attr_reader :dojo, :id

    def path
      Katas.new(dojo).path + id[0..1] + '/' + id[2..-1] + '/'
    end

    def start_avatar
      dojo.paas.start_avatar(self)
    end

    def avatars
      Avatars.new(self)
    end

  end

end
