
module FileDeltaMaker

  def self.make_delta(was, now)
    result = {
      :unchanged => [ ],
      :changed   => [ ],
      :deleted   => [ ]
    }

    was.each do |filename,hash|
      if now[filename] == hash
        result[:unchanged] << filename
      elsif now[filename] != nil
        result[:changed] << filename
      else
        result[:deleted] << filename
      end
      now.delete(filename)
    end

    result[:new] = now.keys
    result
  end

end
