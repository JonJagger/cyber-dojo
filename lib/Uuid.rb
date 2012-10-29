
module Uuid
  
  def self.gen
    # a raw uuidgen has 32 chars hex.
    `uuidgen`.strip.delete('-')[0..9].upcase
  end
  
end