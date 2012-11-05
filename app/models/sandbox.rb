
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
    output
  end
  
  def inner_run(language, visible_files)
    visible_files.each do |filename,content|
      save_file(filename, content)
    end
    link_files(language.dir, language.support_filenames)
    link_files(language.dir, language.hidden_filenames)
    
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    max_run_tests_duration = (test_timeout || 10)
    Files::popen_read(command, max_run_tests_duration)
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
    # .sh files (eg cyberdojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

private

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
