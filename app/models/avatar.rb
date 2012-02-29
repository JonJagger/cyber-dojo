
require 'test_runner_helper.rb'
require 'Locking'
require 'Files'

class Avatar

  include MakeTimeHelper
  include TestRunnerHelper
  include ParseRunTestsOutputHelper
  
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
      
  def run_tests(visible_files)
    output = ''
    Locking::io_lock(dir) do
      # These next four lines are the essence of the execution
      # They should be refactored into a dedicated class
      # which could then be moved to a dedicated server.
      output = avatar_run_tests(sandbox, visible_files)
      visible_files['output'] = output
      inc = parse(@kata.unit_test_framework, output)
      inc[:time] = make_time(Time::now)
      
      increments = locked_read(Increments_filename)
      increments << inc
      inc[:number] = increments.length
      Files::file_write(pathed(Increments_filename), increments)
      Files::file_write(pathed(Manifest_filename), visible_files)
      tag = increments.length
      git_commit_tag(visible_files, tag)
    end
    output
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
      save_file(sandbox, filename, content)
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


