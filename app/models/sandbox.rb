
require 'DiskFile'
require 'TimeBoxedTask'

class Sandbox
  
  def initialize(avatar)
    @avatar = avatar
    @file = Thread.current[:file] || DiskFile.new
    @git  = Thread.current[:git]  || DiskGit.new
    @task = Thread.current[:task] || TimeBoxedTask.new
  end
     
  def dir
    @avatar.dir + @file.separator + 'sandbox'
  end
    
  def save(files)
    files.each do |filename,content|
      @file.write(dir, filename, content)
    end    
  end
  
  def link(language_dir, language_support_filenames)
    language_support_filenames.each do |filename|
      old_name = language_dir + @file.separator + filename
      new_name = dir + @file.separator + filename
      @file.symlink(old_name, new_name)
    end        
  end
  
  def test(delta, visible_files, max_run_tests_duration = 15)    
    delta[:changed].each do |filename|
      @file.write(dir, filename, visible_files[filename])
    end    
    delta[:new].each do |filename|
      @file.write(dir, filename, visible_files[filename])
      @git.add(dir, filename)
    end
    delta[:deleted].each do |filename|
      @git.rm(dir, filename)  
    end    
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    output = @task.execute(command, max_run_tests_duration)
    # create output file so it appears in diff-view
    @file.write(dir, 'output', output)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)    
  end
  
end
