require 'Files'

module TestRunnerHelper

  def avatar_run_tests(avatar_sandbox, visible_files)
    recreate_new(avatar_sandbox)
    visible_files.each do |filename,file|
      save_file(avatar_sandbox, filename, file)
    end
   
    command  = "cd '#{sandbox}';" +
               "./cyberdojo.sh"
    max_run_tests_duration = 10
    output = Files::popen_read(command, max_run_tests_duration)
    save_file(avatar_sandbox, 'output', output )
    output
  end

  def recreate_new(sandbox)
    command = ''
    command += "rm -f #{sandbox}/*;"
    command += "rmdir #{sandbox};"
    command += "mkdir #{sandbox};"
    # sandbox were copying from may have no hidden files but
    # we don't care about that, so pipe diagnostic
    #   "ln .../sandbox/*: No such file or directory"
    # to dev/null so tests run clean
    command += "ln #{sandbox}/../../sandbox/* #{sandbox} >& /dev/null;"
    # Hmmm, that previous command is a virtual duplicate of
    # initial_file_set.rb::copy_hidden_files_to(dir)
    #
    system(command)
  end

  def save_file(foldername, filename, content)
    path = foldername + '/' + filename
    # No need to lock when writing these files. They are write-once-only
    File.open(path, 'w') do |fd|
      filtered = makefile_filter(filename, content)
      fd.write(filtered)
    end
    # .sh files (eg cyberdojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

  # makefiles are tab sensitive...
  # The CyberDojo editor intercepts tab keys and replaces them with spaces.
  # Hence this special filter, just for makefiles to convert leading spaces 
  # back to a tab character. 

  def makefile_filter(name, content)
    if name.downcase == 'makefile'
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

end


