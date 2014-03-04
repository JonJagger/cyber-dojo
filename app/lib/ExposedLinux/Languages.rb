
module ExposedLinux

  class Languages
    include Enumerable

    def initialize(paas,dojo)
      @paas,@dojo = paas,dojo
    end

    def each
      @paas.languages_each(@dojo) do |name|
        yield self[name]
      end
    end

    def [](name)
      Language.new(@dojo,name)
    end
  end

end
