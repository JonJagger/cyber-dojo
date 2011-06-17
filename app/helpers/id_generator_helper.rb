module IdGeneratorHelper
  class IdGenerator
    
    def initialize(prefix)
      @prefix = prefix
      @n = 0
    end
    
    def id
      @n += 1
      @prefix + @n.to_s
    end
    
  end
end
