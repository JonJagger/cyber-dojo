
# Simple class to generate id's for the filename list.
# The filename itself cannot be used as an id since there
# are many more legal characters a filename can have than
# there are legal characters an id can have.

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

