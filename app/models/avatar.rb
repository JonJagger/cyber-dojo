
require 'DiskFile'
require 'DiskGit'

class Avatar

  def self.create(kata, name)
    # To start an animal in a kata, call this.
    avatar = Avatar.new(kata, name)
    avatar.setup
    avatar
  end

  def self.names
    # no two animals start with the same letter
    %w(
        alligator buffalo cheetah deer
        elephant frog gorilla hippo
        koala lion moose panda
        raccoon snake wolf zebra
      )
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def initialize(kata, name)
    # To create an object to represent an animal which has
    # already started a kata, call this.
    @kata = kata
    @name = name
    @file = Thread.current[:file] || DiskFile.new
    @git = Thread.current[:git] || DiskGit.new
  end
  
  def setup
    save(@kata.visible_files, traffic_lights = [ ])
    sandbox.save(@kata.visible_files)
    @git.init(dir, "--quiet")
    @git.add(dir, Traffic_lights_filename)
    @git.add(dir, Visible_files_filename)      
    git_commit(@kata.visible_files, tag = 0)
  end
  
  def dir
    @kata.dir + @file.separator + name
  end
  
  def kata
    @kata
  end
  
  def name
    @name
  end
      
  def save_run_tests(visible_files, traffic_light)    
    traffic_lights = nil
    @file.lock(dir) do
      traffic_lights = eval @file.read(dir, Traffic_lights_filename)
      traffic_lights << traffic_light
      tag = traffic_lights.length
      traffic_light[:number] = tag
      save(visible_files, traffic_lights)
      git_commit(visible_files, tag)
    end
    traffic_lights
  end

  def visible_files(tag = nil)
    eval unlocked_read(Visible_files_filename, tag)
  end
  
  def traffic_lights(tag = nil)
    eval unlocked_read(Traffic_lights_filename, tag)
  end

  def diff_lines(was_tag, now_tag)
    command = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    @git.diff(dir, command)
  end
  
  def sandbox
    Sandbox.new(self)
  end
  
private

  def save(visible_files, traffic_lights)
    @file.write(dir, Visible_files_filename, visible_files)
    @file.write(dir, Traffic_lights_filename, traffic_lights)
  end

  def git_commit(visible_files, tag)
    visible_files.keys.each do |filename|
      @git.add(dir, "sandbox/#{filename}")
    end
    @git.commit(dir, "-a -m '#{tag}' --quiet")
    @git.tag(dir, "-m '#{tag}' #{tag} HEAD")
  end
  
  def unlocked_read(filename, tag)
    @file.lock(dir) {
      locked_read(filename, tag)
    }
  end
  
  def locked_read(filename, tag)    
    if tag != nil
      @git.show(dir, "#{tag}:#{filename}")
    else
      @file.read(dir, filename)
    end
  end
  
  Traffic_lights_filename = 'increments.rb'
  # Used to display the traffic-lights at the bottom of the
  # animals test page, and also to display the traffic-lights for
  # an animal on the dashboard page.
  # It is part of the git repository and is committed every run-test.
  
  Visible_files_filename = 'manifest.rb'
  # Used to retrieve (via a single file access) the visible
  # files needed when resuming an animal.
  # It is part of the git repository and is committed every run-test.
end


