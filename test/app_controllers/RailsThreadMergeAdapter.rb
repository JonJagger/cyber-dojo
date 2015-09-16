
# Ensures multiple threads all use the same test object.
# Is there a Rails incantation to coax it into using a single thread?

class RailsThreadMergeAdapter
  
  def initialize(klass_name)
    @klass_name = klass_name
  end

  def method_missing(sym, *args, &block)
    @@adaptee ||= Object.const_get(@klass_name).new
    @@adaptee.send(sym, *args, &block)
  end

  def self.reset
    @@adaptee = nil
  end
  
end
