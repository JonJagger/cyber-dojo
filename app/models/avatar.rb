
require 'CodeSaver'
require 'Files'
require 'Locking'

class Avatar

  def self.names
    %w(
        alligator buffalo cheetah deer
        elephant frog gorilla hippo
        koala lion moose panda
        raccoon snake wolf zebra
      )
  end

  def initialize(kata, name) 
    @kata = kata
    @name = name
    if !File.exists? dir
      Dir::mkdir(dir)   
      Dir::mkdir(sandbox)      
      Files::file_write(pathed(Manifest_filename), @kata.visible_files)
      Files::file_write(pathed(Increments_filename), [ ])
      command  = "cd '#{dir}';" +
                 "git init --quiet;" +
                 "git add '#{Manifest_filename}';" +
                 "git add '#{Increments_filename}';"
      system(command)
      git_commit_tag(@kata.visible_files, tag = 0)
    end
  end
  
  def kata
    @kata
  end
  
  def name
    @name
  end
      
  def save_run_tests(visible_files, inc)
    Locking::io_lock(dir) do
      increments = locked_read(Increments_filename)
      tag = increments.length + 1
      inc[:number] = tag
      Files::file_write(pathed(Increments_filename), increments << inc)
      Files::file_write(pathed(Manifest_filename), visible_files)
      git_commit_tag(visible_files, tag)
    end
  end

  def visible_files(tag = nil)
    unlocked_read(Manifest_filename, tag)
  end

  def increments(tag = nil)
    unlocked_read(Increments_filename, tag)
  end
  
  def dir
    @kata.dir + '/' + name
  end
  
  def sandbox
    pathed('sandbox')
  end

private
    
  def git_commit_tag(visible_files, tag)
    command = "cd '#{dir}';"
    visible_files.each do |filename,content|
      CodeSaver::save_file(sandbox, filename, content)
      command += "git add '#{sandbox}/#{filename}';"
    end
    command += "git commit -a -m '#{tag}' --quiet;"
    command += "git tag -m '#{tag}' #{tag} HEAD;"
    system(command)   
  end
  
  def unlocked_read(filename, tag)
    Locking::io_lock(dir) { locked_read(filename, tag) }
  end
  
  def locked_read(filename, tag = nil)
    tag ||= most_recent_tag
    command  = "cd #{dir};" +
               "git show #{tag}:#{filename}"
    eval Files::popen_read(command)     
  end
     
  def most_recent_tag
    command  = "cd #{dir};" +
               "git tag|sort -g"
    eval Files::popen_read(command)    
  end
  
  def pathed(filename)
    dir + '/' + filename
  end
      
  Increments_filename = 'increments.rb'  
  Manifest_filename = 'manifest.rb'

end


