
require 'Files'

class Sandbox
  
  def initialize(root_dir)
    @root_dir,@name = root_dir,`uuidgen`.strip.delete('-')[0..9]
  end
     
  def make_dir
    if !File.exists? dir
      Dir.mkdir dir        
    end
  end
  
  def dir
    @root_dir + '/sandboxes/' + @name
  end
    
  def run(language, visible_files)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # visible_files  are the code files from the browser (or test)
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
    language.hidden_filenames.each do |hidden_filename|
      system("ln '#{language.dir}/#{hidden_filename}' '#{dir}/#{hidden_filename}'")
    end
    command  = "cd '#{dir}';" +
               "./cyberdojo.sh"
    max_run_tests_duration = 10
    Files::popen_read(command, max_run_tests_duration)
  end
  
  def save_file(filename, content)
    path = dir + '/' + filename
    # No need to lock when writing these files.
    # They are write-once-only
    File.open(path, 'w') do |fd|
      fd.write(makefile_filter(filename, content))
    end
    # .sh files (eg cyberdojo.sh) need execute permissions
    File.chmod(0755, path) if filename =~ /\.sh/    
  end

private

  def makefile_filter(name, content)
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    # makefiles are tab sensitive...
    # The CyberDojo editor intercepts tab keys and replaces them with spaces.
    # Hence this special filter, just for makefiles to convert leading spaces 
    # back to a tab character.
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
