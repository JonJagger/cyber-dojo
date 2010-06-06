
class TestRunner

  def self.run_tests(kata, manifest)
    sandbox = kata.avatar.folder + '/' + 'sandbox'
    # Reset sandbox to contain just hidden files
    remove_all_but(sandbox, kata.hidden_filenames) # kata.file_set.hidden)
    # Copy in visible files from this increment
    manifest[:visible_files].each { |filename,file| save_file(sandbox, filename, file) }

    # TODO: run as a user with only execute rights; maybe using qemu
    # Run tests in sandbox in dedicated thread
    run_tests_output = []
    sandbox_thread = Thread.new do
      # o) run kata.sh, capturing stdout _and_ stderr    
      # o) popen runs its command as a subprocess
      # o) splitting and joining on "\n" removes any operating 
      #    system differences regarding new-line conventions
      run_tests_output = IO.popen("cd #{sandbox}; ./kata.sh 2>&1").read.split("\n").join("\n")
    end

    # Build and run tests has limited time to complete
    kata.max_run_tests_duration.times do
      sleep(1)
      break if sandbox_thread.status == false 
    end
    # If tests didn't finish assume they were stuck in 
    # an infinite loop and kill the thread
    if sandbox_thread.status != false 
      sandbox_thread.kill 
      run_tests_output = [ "execution terminated after #{kata.max_run_tests_duration} seconds" ]
    end

    run_tests_output
  end

  # Remove all files from the sandbox except the hidden files
  # specified in the katalogue manifest. For example, if the
  # the kata is a java kata and :hidden_files => [ 'junit-4.7.jar' ]
  # then this function will execute the following system command
  #   find sandbox ( ! -samefile "." ! -samefile "junit-4.7.jar" ) -print0 | xargs -0 rm -f
  # with appropriate backslashses. This finds all the files in sandbox that are _not_
  # the . file or junit-4.7.jar and pipes them to rm. 
  def self.remove_all_but(sandbox, these)
    s = "\\! -samefile \".\" "
    these.each {|n| s += "\\! -samefile \"#{sandbox}/#{n}\" " }
    cmd = "find #{sandbox} \\( " + s + " \\) -print0 | xargs -0 rm -f"
    system(cmd)
  end

  def self.save_file(foldername, filename, file)
    path = foldername + '/' + filename
    # No need to lock when writing these files. They are write-once-only
    File.open(path, 'w') do |fd|
      filtered = makefile_filter(filename, file[:content])
      fd.write(filtered)
    end
    # .sh files (eg kata.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

  # Tabs are a problem for makefiles since makefiles are tab sensitive.
  # You can't enter a tab in a plain textarea (it simply moves the
  # cursor based on the tabindex setting) and makefiles need leading
  # whitespace to be tabs. Hence this special filter, just for makefiles 
  # to convert leading spaces to a tab character. 
  def self.makefile_filter(name, content)
    if name.downcase == 'makefile'
      lines = []
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


