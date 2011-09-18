class Increment
  def self.all(hashes)
    hashes.map { |hash| Increment.new(hash) }
  end
  
  def initialize(hash)
    @hash = hash
  end
  
  def time; DateTime.new(*self[:time]); end

  def old?; time < 10.minutes.ago; end
  
  def passed?; self[:outcome] == :passed; end
  
  def [](key)
    @hash[key]
  end
  
  def to_hash
    @hash
  end
end
