
module ExposedLinux

  class Languages
    include Enumerable

    def initialize(dojo)
      @dojo = dojo
    end

    attr_reader :dojo

    def each
      dojo.paas.languages_each(self) do |name|
        yield self[name]
      end
    end

    def [](name)
      Language.new(dojo,name)
    end
  end

end
