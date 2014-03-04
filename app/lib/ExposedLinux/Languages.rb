
module ExposedLinux

  class Languages
    include Enumerable

    def initialize(dojo)
      @dojo = dojo
    end

    def each
      @dojo.paas.languages_each(@dojo) do |name|
        yield self[name]
      end
    end

    def [](name)
      Language.new(@dojo,name)
    end
  end

end
