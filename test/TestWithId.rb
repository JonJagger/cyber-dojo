
class TestWithId

  def initialize(klass)
    @klass = klass
    @args = ARGV.sort.uniq - ['--']
    @seen = []   
    ObjectSpace.define_finalizer( self, self.finalize() )
  end

  def finalize
    proc { 
      unseen = @args - @seen
      warning("tests#{unseen} not found") if unseen != []  
    }
  end
  
  def [](id)
    fatal("tests[#{id}] already encountered") if @seen.include?(id)
    @seen << (@id = id)
    self
  end

  def test(id=@id,name,&block)
    if @args==[]
      @klass.instance_eval { define_method("test__#{name}".to_sym, &block) }
    end 
    if @args.include?(id)
      @seen << id
      @klass.instance_eval { define_method("test__#{name}".to_sym, &block) }
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
