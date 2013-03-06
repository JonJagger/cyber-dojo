
require 'Files'
require 'Folders'
require 'Uuid'

class Sandbox
  attr_accessor :test_timeout
  
  def initialize(root_dir, id, avatar_name)
    @root_dir = root_dir
    @id = Uuid.new(id)
    @avatar_name = avatar_name
  end
     
  def dir
    @root_dir + '/sandboxes/' + @id.inner + '/' + @id.outer + '/' + @avatar_name + '/'
  end
    
  def make_dir
    Folders::make_folder(dir)
  end
  
  def run(language, visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # language       the language object (associated with
    #                the visible_files), which may provide hidden_files
    # visible_files  the code/test files from the browser
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    make_dir
    output = inner_run(language, visible_files)
    system("rm -rf #{dir}")
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end
  
  def inner_run(language, visible_files)
    visible_files.each do |filename,content|
      save_file(filename, content)
    end
    link_files(language.dir, language.support_filenames)
    link_files(language.dir, language.hidden_filenames)
    
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

  def save_file(filename, content)
    path = dir + '/' + filename
    # if file is in a folder make the folder
    Folders::make_folder(path)
    # No need to lock when writing these files.
    # They are write-once-only
    File.open(path, 'w') do |fd|
      fd.write(makefile_filter(filename, content))
    end
    # .sh files (eg cyber-dojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
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
  
  def makefile_filter(name, content)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # The jquery-tabby.js plugin intercepts tab key presses in the
    # textarea editor and converts them to spaces for a better
    # editing experience. However, makefiles are tab sensitive...
    # Hence this special filter, just for makefiles, to convert
    # leading spaces back to a tab character.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
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
