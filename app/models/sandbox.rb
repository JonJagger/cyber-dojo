
require 'Files'
require 'Folders'

class Sandbox
  attr_accessor :test_timeout
  
  def initialize(root_dir, id, avatar_name)
    @root_dir, @id, @avatar_name = root_dir, id, avatar_name
  end
     
  def dir
    @root_dir + '/sandboxes/' + inner_dir + '/' + outer_dir + '/' + @avatar_name + '/'
  end
    
  def make_dir
    Folders::make_folder(dir)
  end
  
  def run(language, visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # visible_files  the code/test files from the browser
    # language       the language object (associated with
    #                the visible_files), which may provide hidden_files
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
               "./#{cyberdojo_shell_filename(visible_files)}"
    max_run_tests_duration = (test_timeout || 10)
    Files::popen_read(command, max_run_tests_duration)
  end
  
  def cyberdojo_shell_filename(visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    # I have changed the shell filename in the exercises/ folders from
    # cyberdojo.sh (no hyphen) to cyber-dojo.sh (with a hyphen) to match
    # the cyber-dojo.com domain name. However, I still need to support old
    # sessions, particularly the ability to fork from a new session from an
    # old diff-view, e.g. the refactoring setups in
    # http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html
    # See also app/assets/javascripts/cyberdojo-file_load.js
    # See also app/assets/javascripts/cyberdojo-files.js
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    old_name = 'cyberdojo.sh'
    new_name = 'cyber-dojo.sh'
    if visible_files[new_name] != nil
      return new_name
    else
      return old_name
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
    # .sh files (eg cyberdojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

private

  def inner_dir
    @id[0..1]
  end

  def outer_dir
    @id[2..-1]
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
