
require 'Disk'
require 'TimeBoxedTask'

class Sandbox
  
  def initialize(avatar)
    @avatar = avatar
    @disk = Thread.current[:disk] || Disk.new
    @git  = Thread.current[:git]  || DiskGit.new
    @task = Thread.current[:task] || TimeBoxedTask.new
  end
     
  def dir
    @avatar.dir + file_separator + 'sandbox'
  end
    
  def save(files)
    files.each do |filename,content|
      @disk.write(dir, filename, content)
    end    
  end
  
  def link(language_dir, language_support_filenames)
    language_support_filenames.each do |filename|
      old_name = language_dir + file_separator + filename
      new_name = dir + file_separator + filename
      @disk.symlink(old_name, new_name)
    end        
  end
  
  def test(delta, visible_files, max_duration = 15)    
    delta[:changed].each do |filename|
      @disk.write(dir, filename, visible_files[filename])
    end    
    delta[:new].each do |filename|
      @disk.write(dir, filename, visible_files[filename])
      @git.add(dir, filename)
    end
    delta[:deleted].each do |filename|
      @git.rm(dir, filename)  
    end    
    command  = "cd '#{dir}';" +
               "./cyber-dojo.sh"
    output = @task.execute(command, max_duration)
    # create output file so it appears in diff-view
    @disk.write(dir, 'output', output)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)    
  end
  
private

  def file_separator
    @disk.file_separator
  end
  
end
