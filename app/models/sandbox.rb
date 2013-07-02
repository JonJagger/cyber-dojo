
require 'DiskFile'
require 'TimeBoxedTask'

class Sandbox
  
  def initialize(avatar)
    @avatar = avatar
    @file = Thread.current[:file] || DiskFile.new
    @task = Thread.current[:task] || TimeBoxedTask.new
  end
     
  def dir
    @avatar.dir + @file.separator + 'sandbox'
  end
    
  def save(visible_files)
    # Save each file individually. Enables the 'git diff' 
    # command in avatar.diff_lines() and hence the diff page.
    visible_files.each do |filename,content|
      @file.write(dir, filename, content)
    end    
  end
  
  def run_tests(visible_files, max_run_tests_duration = 15)
    # TODO: don't delete the sandbox every run-tests    
    #       When the sandbox folder is _not_ deleted for
    #       each run-tests then I should be able to do the link_files
    #       just the once in the avatar c'tor.
    @file.rm_dir(dir)
    save(visible_files)
    language = @avatar.kata.language
    link_files(language, language.support_filenames)
    link_files(language, language.hidden_filenames)        
    # TODO: I think the hidden files should be copied.
    # The difference between support and hidden is essentially
    # that support files need to be linked, so otherwise
    # what is the difference?
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    output = @task.execute(command, max_run_tests_duration)
    @file.write(dir, 'output', output)
    visible_files['output'] = output
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def link_files(language, link_filenames)
    link_filenames.each do |filename|
      old_name = language.dir + @file.separator + filename
      new_name = dir + @file.separator + filename
      @file.symlink(old_name, new_name)
    end    
  end
  
end
