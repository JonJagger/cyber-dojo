
require 'test_runner_helper.rb'
require 'Locking'
require 'Files'

class Avatar

  include MakeTimeHelper
  include TestRunnerHelper
  include Files
  include Locking
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
      
      file_write(pathed(Manifest_filename), visible_files)
      file_write(pathed(Increments_filename), [ ])
      
      command  = "cd '#{dir}';" +
                 "git init --quiet;" +
                 "git add '#{Manifest_filename}';" +
                 "git add '#{Increments_filename}';"
      system(command)
      tag = 0
      git_commit_tag(visible_files, tag)
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
    io_lock(dir) do
      output = avatar_run_tests(sandbox, visible_files)
      visible_files['output'] = output
      test_info = parse(@kata.unit_test_framework, output)
      
      incs = locked_increments     
      incs << test_info
      test_info[:time] = make_time(Time::now)
      test_info[:number] = incs.length
      save_run_tests_outcomes(incs, visible_files)
    end
    output
  end

  def visible_files(tag = nil)
    seen = ''
    io_lock(dir) do
      tag ||= most_recent_tag      
      command  = "cd #{dir};" +
                 "git show #{tag}:#{Manifest_filename}"
      seen = popen_read(command) 
    end
    eval seen
  end

  def increments(tag = nil)
    io_lock(dir) { locked_increments(tag) }
  end
  
  def dir
    @kata.dir + '/' + name
  end
  
  def sandbox
    pathed('sandbox')
  end

private
  
  def save_run_tests_outcomes(increments, visible_files)
    file_write(pathed(Increments_filename), increments)
    file_write(pathed(Manifest_filename), visible_files)
    tag = increments.length
    git_commit_tag(visible_files, tag)
  end
  
  def pathed(filename)
    dir + '/' + filename
  end

  def most_recent_tag
    command  = "cd #{dir};" +
               "git tag|sort -g"
    eval popen_read(command)    
  end
  
  def git_commit_tag(visible_files, n)
    command = "cd '#{dir}';"
    visible_files.each do |filename,|
      command += "git add '#{sandbox}/#{filename}';"
    end
    command += "git commit -a -m '#{n}' --quiet;"
    command += "git tag -m '#{n}' #{n} HEAD;"
    system(command)   
  end
  
  def locked_increments(tag = nil)
    if tag == nil
      eval IO.read(pathed(Increments_filename))
    else
      command  = "cd #{dir};" +
                 "git show #{tag}:#{Increments_filename}"
      eval popen_read(command)
    end
  end

  Increments_filename = 'increments.rb'  
  Manifest_filename = 'manifest.rb'

end


