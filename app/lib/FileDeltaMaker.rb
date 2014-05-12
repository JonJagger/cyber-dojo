
module FileDeltaMaker

  # Noticeably absent from this is :renamed
  # If browser file new/rename/delete events all
  # caused a git-tag on the server I could capture
  # file renames. Should result in better diffs.
  # This would mean a git_mv() method.
  # It would also open up the architecture to
  # finer grained commits. Eg a next logical
  # step would be to tag-commit when switching files.
  # When this is coded be careful that a :renamed
  # is not *also* seen as a :deleted

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
