
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
  
  def run(language, visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # language       the language object (associated with
    #                the visible_files), which may provide hidden_files
    # visible_files  the code/test files from the browser
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    system("rm -rf #{dir}")
    # TODO: don't delete the sandbox every run-tests
    output = inner_run(language, visible_files)
    Files::file_write(dir + 'output', output)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end
  
  def inner_run(language, visible_files)
    save(visible_files)
    link_files(language.dir, language.support_filenames)
    link_files(language.dir, language.hidden_filenames)    
    # TODO: When the sandbox folder is _not_ deleted for
    # each run-tests then I should be able to do the link_files
    # just the once in the avatar c'tor.
    # TODO: should the hidden files be linked or copied?
    
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    max_run_tests_duration = (test_timeout || 15)
    output = Files::popen_read(command, max_run_tests_duration)
    update_visible_files_with_text_files_created_and_deleted_in_test_run(dir, visible_files)
    output
  end

  def update_visible_files_with_text_files_created_and_deleted_in_test_run(test_run_dir, visible_files)
    txt_files = Folders.in(test_run_dir).select do |entry|
      entry.end_with?('.txt')
    end
    txt_files.each do |filename|
      visible_files[filename] = read_file(Pathname.new(test_run_dir).join(filename))
    end
    visible_files.delete_if do |filename, value| 
      filename.end_with?(".txt") and not Folders.in(test_run_dir).include?(filename)
    end
  end

private

  def read_file(filename)
    data = ''
    f = File.open(filename, "r")
    f.each_line do |line|
      line = line.gsub /\r\n?/, "\n"
      data += line
    end
    f.close()
    return data
  end

  def link_files(link_dir, link_filenames)
    link_filenames.each do |filename|
      system("ln '#{link_dir}/#{filename}' '#{dir}/#{filename}'")
    end    
  end

end
