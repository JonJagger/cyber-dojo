
module Files
  
  def self.file_write(path, object)
    # When doing a git diff on a repository that includes files created
    # by this function I found the output contained extra lines thus
    # \ No newline at end of file
    # So I've appended a newline to help keep git quieter.
    File.open(path, 'w') { |file| file.write object.inspect + "\n" }
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
  
  def self.popen_read(command, max_seconds = nil)
    # Originally I was writing
    #   eval IO::popen(cmd).read
    # However, this was leaving many [sh <defunct>] processes.
    # Googling, reveals that this means that the parent process
    # had not yet wait()ed for it to finish.
    # The popen call turned out to be the culprit.
    #
    # Furthermore, killing a process does not necessarily kill its child processes. 
    # So that has to be coded. At first I killed all the descendant processes in 
    # an ensure block. However this...
    #   http://blog.headius.com/2008/02/rubys-threadraise-threadkill-timeoutrb.html
    # says there is a ruby bug in the interaction between Thread.kill and ensure,
    # and I seemed to be hitting that.
    # So I have refactored: now the descendent processes are killed outside of
    # an ensure block.
    pipe = IO::popen(with_stderr(command))
    
    output = ""
    if max_seconds == nil
      output += pipe.read
      timed_out = false
    else
      sandbox_thread = Thread.new { output += pipe.read }    
      result = sandbox_thread.join(max_seconds);
      timed_out = (result == nil)
    end
    
    # Is this overkill... Can't I just do this...
    #   `kill -9 -#{pipe.pid}`
    # or do I need...
    #   `kill -9 -#{Process.getpgid(pipe.pid)}`
    # or even better...
    #   `kill -9 -#{pipe.gid}`
    
    kill(descendant_pids_of(pipe.pid))
    
    if sandbox_thread != nil
      Thread.kill(sandbox_thread)
    end
    
    pipe.close

    if timed_out
      output += "Terminated by the CyberDojo server after #{max_seconds} seconds."
    end
    
    output
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
  def self.with_stderr(cmd)
    cmd + " " + "2>&1"
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  
  def self.kill(pids)
    return if pids == [ ]
    begin
      `kill #{pids.join(' ')}`
    rescue
      # Could happen if the OS/GC reclaims the process? 
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  
  def self.descendant_pids_of(base)
    # From http://t-a-w.blogspot.com/2010/04/how-to-kill-all-your-children.html
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