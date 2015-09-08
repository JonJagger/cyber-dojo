
class TestWithId

  def initialize(klass)
    @klass = klass
    @args = ARGV.sort.uniq - ['--']
    @ids = []   
    ObjectSpace.define_finalizer( self, self.finalize() )
  end

  def finalize
    proc { warning("tests#{@args} not found") if @args != []  }
  end
  
  def [](id)
    fatal("tests[#{id}] already encountered") if @ids.include?(id)
    @ids << (@id = id)
    self
  end

  def is(id=@id,name,&block)
    if @args==[] || @args.include?(id)
      @args.delete(id)
      @klass.instance_eval { define_method("test_[#{id}].#{name}".to_sym, &block) }
    end 
  end

private

  def fatal(message)
    warning(message)
    abort
  end

  def warning(message)
    puts '>' * 35
    puts message
    puts '>' * 35
  end

end
