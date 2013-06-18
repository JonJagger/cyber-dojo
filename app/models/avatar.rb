
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
      save(@kata.visible_files, traffic_lights = [ ])
      sandbox.save(@kata.visible_files)
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
      
  def save_run_tests(visible_files, inc)    
    traffic_lights = nil
    inc[:time] = make_time(Time.now) # TODO: move to kata_controller?
    Locking::io_lock(dir) do
      increments = locked_read(Increments_filename)
      tag = increments.length + 1
      inc[:number] = tag
      traffic_lights = increments << inc
      
      # traffic_lights = locked_read(Increments_filename)
      # traffic_lights << traffic_light
      # tag = traffic_lights.length
      # traffic_light[:number] = tag
      
      save(visible_files, traffic_lights)
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
  
  def sandbox
    Sandbox.new(self)
  end
  
private

  def save(visible_files, traffic_lights)
    Files::file_write(dir + '/' + Manifest_filename, visible_files)
    Files::file_write(dir + '/' + Increments_filename, traffic_lights)
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
  # Contains all the traffic-lights so far.
  # It is used to display the traffic-lights at the bottom of the
  # animals test page, and also to display the traffic-lights for
  # an animal on the dashboard page.
  # It is part of the git repository and is committed every run-test.
  
  Manifest_filename = 'manifest.rb'
  # Contains all the visible files (as an inspected ruby object).
  # It is used to retrieve (via a single file access) the visible
  # files needed when resuming an animal.
  # It is part of the git repository and is committed every run-test.
end


