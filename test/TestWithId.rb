
class TestWithId

  def initialize(klass)
    @klass = klass
    @args = ARGV.sort.uniq - ['--']
    @seen = []   
    ObjectSpace.define_finalizer( self, self.finalize() )
  end

  def finalize
    proc { warning("tests#{unseen_ids} not found") if unseen_ids != [] }
  end
  
  def [](id)
    fatal("tests[#{id}] already encountered") if @seen.include?(id)
    @seen << (@id = id)
    self
  end

  def test(id=@id,name,&block)
    if @args==[] || @args.include?(id)
      @seen << id
      @klass.instance_eval { define_method("test__[#{id}]__#{name}".to_sym, &block) }
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

  def unseen_ids
    @args - @seen
  end

end
