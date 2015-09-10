
module FileDeltaMaker # mix-in

  module_function

  # make_delta finds out which files are :new, :unchanged, :changed, or :deleted.
  # It ensures files deleted in the browser are correspondingly deleted under katas/
  # It also allows unchanged files to *not* be (re)saved. 
  # Unfortunately using DockerGitCloneRunner each test event causes a git-clone
  # and Git does *not* record timestamps so it's not much of an optimization.

  def make_delta(was, now)    
    now_keys = now.keys.clone    
    result =
    {
      :unchanged => [ ],
      :changed   => [ ],
      :deleted   => [ ]
    }
    was.each do |filename,hash|
      if now[filename] == hash
        result[:unchanged] << filename
      elsif !now[filename].nil?
        result[:changed] << filename
      else
        result[:deleted] << filename
      end
      now_keys.delete(filename)
    end
    result[:new] = now_keys
    result
  end

end
