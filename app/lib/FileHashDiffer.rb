
module FileHashDiffer
  
  def self.diff(incoming, outgoing)
    filenames = {
      :unchanged => [ ],
      :changed   => [ ],
      :deleted   => [ ]
    }
  
    incoming.each do |filename,hash|
      if outgoing[filename] == hash
        filenames[:unchanged] << filename
      elsif outgoing[filename] != nil
        filenames[:changed] << filename
      else
        filenames[:deleted] << filename
      end
      outgoing.delete(filename)
    end
  
    filenames[:new] = outgoing.keys
    filenames
  end
  
end
