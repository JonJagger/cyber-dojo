require 'Folders'

module Files
  
  def self.file_write(dir, filename, object)
    pathed_filename = dir + File::SEPARATOR + filename
    Folders::make_folder(pathed_filename) # if file is in a folder make the folder
    if object.is_a? String
      File.open(pathed_filename, 'w') do |fd|
        fd.write(makefile_filter(pathed_filename, object))
      end
      # .sh files (eg cyber-dojo.sh) need execute permissions
      File.chmod(0755, pathed_filename) if pathed_filename =~ /\.sh/    
    else
      # When doing a git diff on a repository that includes files created
      # by this function I found the output contained extra lines thus
      # \ No newline at end of file
      # So I've appended a newline to help keep git quieter.
      File.open(pathed_filename, 'w') { |file| file.write(object.inspect + "\n") }
    end
  end
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
  
  def self.makefile_filter(pathed_filename, content)
    # The jquery-tabby.js plugin intercepts tab key presses in the
    # textarea editor and converts them to spaces for a better
    # editing experience. However, makefiles are tab sensitive...
    # Hence this special filter, just for makefiles, to convert
    # leading spaces back to a tab character.
    if pathed_filename.downcase.split(File::SEPARATOR).last == 'makefile'
      lines = [ ]
      newline = Regexp.new('[\r]?[\n]')
      content.split(newline).each do |line|
        if stripped = line.lstrip!
          line = "\t" + stripped
        end
        lines.push(line)
      end
      content = lines.join("\n")
    end
    content
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
      output += "Terminated by the cyber-dojo server after #{max_seconds} seconds."
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
    `kill #{pids.join(' ')}`
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