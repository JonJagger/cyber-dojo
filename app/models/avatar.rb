
require 'Files'
require 'Folders'
require 'Locking'
require 'make_time_helper'

class Avatar

  include MakeTimeHelper
  
  def self.names
    # no two animals start with the same letter
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
      visible_files = @kata.visible_files
      visible_files['output'] = ''
      Files::file_write(pathed(Manifest_filename), visible_files)
      Files::file_write(pathed(Increments_filename), [ ])
      sandbox.save(visible_files)
      system(cd_dir('git init --quiet'))
      git_commit(tag = 0)
    end
  end
  
  def kata
    @kata
  end
  
  def name
    @name
  end
      
  def run_tests(language, visible_files)
    sandbox.run(language, visible_files)
  end
  
  def save_run_tests(visible_files, output, inc)    
    traffic_lights = nil
    inc[:time] = make_time(Time.now)
    visible_files['output'] = output
    Locking::io_lock(dir) do
      increments = locked_read(Increments_filename)
      tag = increments.length + 1
      inc[:number] = tag
      traffic_lights = increments << inc
      Files::file_write(pathed(Increments_filename), traffic_lights)
      Files::file_write(pathed(Manifest_filename), visible_files)
      git_commit(tag)
    end
    traffic_lights
  end

  def visible_files(tag = nil)
    unlocked_read(Manifest_filename, tag)
  end
  
  def increments(tag = nil)
    unlocked_read(Increments_filename, tag)
  end

  def diff_lines(was_tag, now_tag)
    command = cd_dir("git diff --ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox")
    Files::popen_read(command)
  end
  
  def dir
    @kata.dir + '/' + name
  end
  
private

  def sandbox
    Sandbox.new(self)
  end
  
  def pathed(filename)
    dir + '/' + filename
  end
      
  def git_commit(tag)
    command =
      [
        "git add .",
        "git commit -a -m '#{tag}' --quiet",
        "git tag -m '#{tag}' #{tag} HEAD",
      ].join(';')
    system(cd_dir(command))
  end
  
  def unlocked_read(filename, tag)
    Locking::io_lock(dir) { locked_read(filename, tag) }
  end
  
  def locked_read(filename, tag = nil)
    tag ||= most_recent_tag
    command = cd_dir("git show #{tag}:#{filename}")
    eval Files::popen_read(command)
  end
     
  def most_recent_tag
    command = cd_dir("git tag|sort -g")
    eval Files::popen_read(command)
  end
  
  def cd_dir(command)
    "cd #{dir};" + command
  end
  
  Increments_filename = 'increments.rb'  
  Manifest_filename = 'manifest.rb'

end


