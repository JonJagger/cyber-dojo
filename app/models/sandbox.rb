
require 'Files'

class Sandbox
  
  def initialize(avatar)
    @avatar = avatar
  end
     
  def dir
    @avatar.dir + File::SEPARATOR + 'sandbox'
  end
    
  def save(visible_files)
    # Save each file individually. Enables the 'git diff' 
    # command in avatar.diff_lines() and hence the diff page.
    visible_files.each do |filename,content|
      Files::file_write(dir, filename, content)
    end    
  end
  
  def run_tests(language, visible_files, max_run_tests_duration = 15)
    # TODO: don't delete the sandbox every run-tests    
    #       When the sandbox folder is _not_ deleted for
    #       each run-tests then I should be able to do the link_files
    #       just the once in the avatar c'tor.
    system("rm -rf #{dir}")
    save(visible_files)
    link_files(language, language.support_filenames)
    link_files(language, language.hidden_filenames)        
    # TODO: I think the hidden files should be copied.
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    output = Files::popen_read(command, max_run_tests_duration)    
    Files::file_write(dir, 'output', output)
    visible_files['output'] = output
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def link_files(language, link_filenames)
    link_filenames.each do |filename|
      old_name = language.dir + File::SEPARATOR + filename
      new_name = dir + File::SEPARATOR + filename
      File.symlink(old_name, new_name)
    end    
  end

end
