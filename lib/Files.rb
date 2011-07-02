module Files
  
  def file_write(path, object)
    # When doing a git diff on a repository that includes files created
    # by this function I found the output contained extra lines thus
    # \ No newline at end of file
    # So I've appended a newline to help keep git quieter.
    File.open(path, 'w') { |file| file.write object.inspect + "\n" }
  end
  
  # Originally I was writing
  #   eval IO::popen(cmd).read
  # However, this was leaving many [sh <defunct>] processes.
  # Googling, reveals that this means that the parent process
  # had not yet wait()ed for it to finish.
  # The popen call turned out to be the culprit.
  #
  # Furthermore,  killing a process does not necessarily kill its child processes. 
  # So that had to be coded. At first I killed all the descendant processes in 
  # an ensure block. However this...
  #   http://blog.headius.com/2008/02/rubys-threadraise-threadkill-timeoutrb.html
  # says there is a ruby bug in the interaction between Thread.kill and ensure,
  # and I seemed to be hitting that on occasion.
  # So I have refactored: now the descendent processes are killed outside of
  # an ensure block.
  
  def popen_read cmd, max_seconds = nil
    output = nil
    pipe = IO::popen(with_stderr(cmd))
    
    if max_seconds == nil
      output = pipe.read
    else
      sandbox_thread = Thread.new { output = pipe.read }    
      sandbox_thread.join(max_seconds)
    end
    
    kill(descendant_pids_of(pipe.pid))
    
    if sandbox_thread != nil
      Thread.kill(sandbox_thread)
    end
    
    pipe.close
    
    output
  end
  
  
  def with_stderr(cmd)
    cmd + " " + "2>&1"
  end
  
  
  def kill(pids)
    return if pids == []
    begin
      `kill #{pids.join(' ')}`
    rescue
      # Could happen if the OS/GC reclaims the process? 
    end
  end
  
  # From http://t-a-w.blogspot.com/2010/04/how-to-kill-all-your-children.html
  
  def descendant_pids_of(base)
    # Autovivify the hash
    descendants = Hash.new { |ht,k| ht[k] = [k] }
    # Get process parentage information and turn it into a hash  
    pid_map = Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{ |x| x.to_i }]
    # For each process, add a reference to its descendants list 
    # to its parent's descendants list    
    pid_map.each{ |pid,ppid| descendants[ppid] << descendants[pid] }
    # Flatten away the generations 
    descendants[base].flatten - [base]
  end

end