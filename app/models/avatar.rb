
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
      # These next three lines are the essence of the execution
      # They should be refactored into a dedicated class
      # which could then be moved to a dedicated server.
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
    Locking::io_lock(dir) do
      tag ||= most_recent_tag      
      command  = "cd #{dir};" +
                 "git show #{tag}:#{Manifest_filename}"
      seen = Files::popen_read(command) 
    end
    eval seen
  end

  def increments(tag = nil)
    # I think I could be over-locking here...
    # if tag is not nil then this runs a
    #    git show #{tag}:filename
    # command which does not need locking.
    # If tag is nil then the tag is retrieved
    # with the command
    #   git tag|sort -g
    # which itself might need to be locked?
    Locking::io_lock(dir) { locked_increments(tag) }
  end
  
  def dir
    @kata.dir + '/' + name
  end
  
  def sandbox
    pathed('sandbox')
  end

private
  
  def save_run_tests_outcomes(increments, visible_files)
    Files::file_write(pathed(Increments_filename), increments)
    Files::file_write(pathed(Manifest_filename), visible_files)
    tag = increments.length
    git_commit_tag(visible_files, tag)
  end
  
  def pathed(filename)
    dir + '/' + filename
  end

  def most_recent_tag
    command  = "cd #{dir};" +
               "git tag|sort -g"
    eval Files::popen_read(command)    
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
    # if tag==nil is it better to instead do
    # tag = most_recent_tag
    # and thus avoid accessing the increments_filename
    # directly? Would this mean I could drop the locking?
    # I think the answer is yes, but it simply transfers
    # any potential problem elsewhere. Viz, if there
    # are two players playing as the same avatar
    # then they could do a run-tests and interfere
    # with each other, but they would at least be atomic
    # because of the io_lock on run_tests.
    if tag == nil
      eval IO.read(pathed(Increments_filename))
    else
      command  = "cd #{dir};" +
                 "git show #{tag}:#{Increments_filename}"
      eval Files::popen_read(command)
    end
  end

  Increments_filename = 'increments.rb'  
  Manifest_filename = 'manifest.rb'

end


