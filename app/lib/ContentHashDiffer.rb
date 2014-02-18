
module ContentHashDiffer
  
  def self.diff(incoming, outgoing)
    result = {
      :unchanged => [ ],
      :changed   => [ ],
      :deleted   => [ ]
    }
  
    incoming.each do |name,hash|
      if outgoing[name] == hash
        result[:unchanged] << name
      elsif outgoing[name] != nil
        result[:changed] << name
      else
        result[:deleted] << name
      end
      outgoing.delete(name)
    end
  
    result[:new] = outgoing.keys
    result
  end
  
end
