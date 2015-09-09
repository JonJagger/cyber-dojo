
module FileDeltaMaker # mix-in

  module_function

  # make_delta finds out which files are :new, :unchanged, :changed, or :deleted.
  # This allows unchanged files to *not* be (re)saved. This is important
  # when using DockerVolumeMountRunner.rb since it creates the possibility of, eg 
  # incremental makefiles. But DockerGitCloneRunner.rb uses Git which, by default,
  # does *not* record timestamps. They can be added back in using the meta store
  # and hooks. But if the timestamps are not preserved then all the delta code
  # can be deleted. Something to be said for that option. Certainly simpler.

  def make_delta(was, now)
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
