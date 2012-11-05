
class Uuid
  
  def initialize(id = `uuidgen`.strip.delete('-')[0..9].upcase)
    # a raw uuidgen has 32 chars hex.
    @id = id
  end
  
  def to_s
    @id
  end
  
  def inner
    @id[0..1]
  end

  def outer
    # outer_dir will be unique inside inner_dir    
    @id[2..-1]
  end
  
end