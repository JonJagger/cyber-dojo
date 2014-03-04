
module ExposedLinux

  class Languages
    include Enumerable

    def initialize(dojo)
      @dojo = dojo
    end

    def each
      @dojo.paas.languages_each {|name| yield Language.new(name) }
    end

  end

end
