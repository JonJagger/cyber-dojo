
class Id

  def initialize(id = `uuidgen`.strip.delete('-')[0...10].upcase)
    # a raw uuidgen has 32 chars hex.
    @id = id
  end

  def valid?
    @id.length === 10 && @id.chars.all?{|ch| hex?(ch)}
  end

  def ==(rhs)
    self.to_s == rhs.to_s
  end

  def to_s
    @id
  end

  def inner
    @id[0...2]
  end

  def outer
    # outer_dir will be unique inside inner_dir
    @id[2..-1] || ""
  end

private

  def hex?(ch)
    "0123456789ABCDEF".include?(ch)
  end

end
