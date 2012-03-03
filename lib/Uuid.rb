
module Uuid
  
  def self.gen
    # a raw uuidgen has 32 chars hex.
    # I strip out the 0s and 1s because they are 
    # similar to Os and Ls - this makes it easier for
    # players to enter the id into the input text.
    # The chance of their being so many 0's and 1's
    # that the resulting id has less than 10 chars is
    # vanishingly small.
    `uuidgen`.strip.delete('-01')[0..9]
  end
  
end