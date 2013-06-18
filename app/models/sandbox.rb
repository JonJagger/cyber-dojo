
require 'Files'
require 'Folders'
require 'Uuid'

class Sandbox
  attr_accessor :test_timeout
  
  def initialize(avatar)
    @avatar = avatar
  end
     
  def dir
    @avatar.dir + '/' + 'sandbox' + '/'
  end
    
  def save(visible_files)
    visible_files.each do |filename,content|
      Files::file_write(dir + filename, content)
    end    
  end
  
  def run_tests(language, visible_files)
    # TODO: don't delete the sandbox every run-tests    
    #       When the sandbox folder is _not_ deleted for
    #       each run-tests then I should be able to do the link_files
    #       just the once in the avatar c'tor.
    #       Should the hidden files be linked or copied?
    system("rm -rf #{dir}")
    save(visible_files)
    link_files(language.dir, language.support_filenames)
    link_files(language.dir, language.hidden_filenames)        
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    max_run_tests_duration = (test_timeout || 15)
    output = Files::popen_read(command, max_run_tests_duration)    
    Files::file_write(dir + 'output', output)
    visible_files['output'] = output
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

private

  def link_files(link_dir, link_filenames)
    link_filenames.each do |filename|
      system("ln '#{link_dir}/#{filename}' '#{dir}/#{filename}'")
    end    
  end

end
