
module ExposedLinux

  class Avatars
    include Enumerable

    def initialize(kata)
      @kata = kata
    end

    attr_reader :kata

    def each
      kata.dojo.paas.avatars_each(kata) do |name|
        yield self[name]
      end
    end

    def [](name)
      Avatar.new(kata,name)
    end

  end

end
