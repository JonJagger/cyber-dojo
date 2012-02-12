
# At the moment almost all the codebase uses each increment (traffic-light) as
# a plain hash (eg inc[:time]) 
# This could be refactored to use this Increment model object instead.
# At the moment the only code that uses this Increment class is the
# auto post message code in avatar.rb mostly written by the awesome
# Johannes Brodwall. 

class Increment
  
  def self.all(hashes)
    hashes.map { |hash| Increment.new(hash) }
  end
  
  def initialize(hash)
    @hash = hash
  end
  
  def time
    DateTime.new(*self[:time])
  end

  def old?
    time < 10.minutes.ago
  end
  
  def passed?
    self[:outcome] == :passed
  end
  
  def [](key)
    @hash[key]
  end
  
  def to_hash
    @hash
  end

end
