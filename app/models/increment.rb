class Increment
  def self.all(hashes)
    hashes.map { |hash| Increment.new(hash) }
  end
  
  def initialize(hash)
    @hash = hash
  end
  
  def passed?; self[:outcome] == :passed; end
  
  def [](key)
    @hash[key]
  end
  
  def hash
    @hash
  end
end
