
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
      
      visible_files = @kata.visible_files
      visible_files.each do |filename,content|
        save_file(sandbox, filename, content)
      end
      
      Files::file_write(pathed(Manifest_filename), visible_files)
      Files::file_write(pathed(Increments_filename), [ ])
      
      command  = "cd '#{dir}';" +
                 "git init --quiet;" +
                 "git add '#{Manifest_filename}';" +
                 "git add '#{Increments_filename}';"
      system(command)
      tag = 0
      git_commit_tag(visible_files, tag)
      # I could do a
      #     run_tests(visible_files) 
      # here giving a new page an initial traffic-light.
      # I don't do this because it slows down startup.
      # But perhaps I could do that from the client side
      # after they have dismissed the welcome dialog...
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
      test_info = parse(@kata.unit_test_framework, output)
      test_info[:time] = make_time(Time::now)
      
      incs = locked_read(Increments_filename)
      incs << test_info
      test_info[:number] = incs.length
      Files::file_write(pathed(Increments_filename), incs)
      Files::file_write(pathed(Manifest_filename), visible_files)
      tag = incs.length
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
    
  def pathed(filename)
    dir + '/' + filename
  end

  def most_recent_tag
    command  = "cd #{dir};" +
               "git tag|sort -g"
    eval Files::popen_read(command)    
  end
  
  def git_commit_tag(visible_files, tag)
    command = "cd '#{dir}';"
    visible_files.each do |filename,|
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
      
  Increments_filename = 'increments.rb'  
  Manifest_filename = 'manifest.rb'

end


