
require 'Disk'
require 'DiskGit'

class Avatar

  def self.create(kata, name)
    # To start an animal in a kata, call this.
    avatar = kata[name]
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
    @disk = Thread.current[:disk] || Disk.new
    @git = Thread.current[:git] || DiskGit.new
    @kata = kata
    @name = name
  end
  
  def exists?
    @disk.exists?(dir)        
  end
  
  def dir
    @kata.dir + file_separator + name
  end
  
  def setup
    @disk.write(dir, visible_files_filename, @kata.visible_files)
    @disk.write(dir, traffic_lights_filename, [ ])
    sandbox.save(@kata.visible_files) # includes output and instructions
    language = @kata.language
    sandbox.link(language.dir, language.support_filenames)
    @git.init(dir, "--quiet")
    @git.add(dir, traffic_lights_filename)
    @git.add(dir, visible_files_filename)      
    git_commit(@kata.visible_files, tag = 0)
  end
  
  def kata
    @kata
  end
  
  def name
    @name
  end
      
  def save_run_tests(visible_files, traffic_light)    
    traffic_lights = nil
    @disk.lock(dir) do
      text = @disk.read(dir, traffic_lights_filename)
      traffic_lights = JSON.parse(JSON.unparse(eval text)) 
      traffic_lights << traffic_light
      tag = traffic_lights.length
      traffic_light['number'] = tag
      @disk.write(dir, traffic_lights_filename, traffic_lights)
      @disk.write(dir, visible_files_filename, visible_files)
      git_commit(visible_files, tag)
    end
    traffic_lights
  end

  def visible_files(tag = nil)
    text = unlocked_read(visible_files_filename, tag)
    JSON.parse(JSON.unparse(eval text))
  end
  
  def traffic_lights(tag = nil)
    text = unlocked_read(traffic_lights_filename, tag)    
    JSON.parse(JSON.unparse(eval text))    
  end

  def diff_lines(was_tag, now_tag)
    # visible_files are saved to the sandbox dir individually.
    command = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    output = @git.diff(dir, command)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)        
  end
  
  def sandbox
    Sandbox.new(self)
  end
  
private

  def file_separator
    @disk.file_separator
  end
  
  def git_commit(visible_files, tag)
    visible_files.keys.each do |filename|
      @git.add(dir, "sandbox/#{filename}")
    end
    # the -a is important for .txt files in approval style tests
    @git.commit(dir, "-a -m '#{tag}' --quiet")
    @git.tag(dir, "-m '#{tag}' #{tag} HEAD")
  end
  
  def unlocked_read(filename, tag)
    @disk.lock(dir) {
      locked_read(filename, tag)
    }
  end
  
  def locked_read(filename, tag)    
    if tag != nil
      @git.show(dir, "#{tag}:#{filename}")
    else
      @disk.read(dir, filename)
    end
  end
  
  def traffic_lights_filename
    # Used to display the traffic-lights at the bottom of the
    # animals test page, and also to display the traffic-lights for
    # an animal on the dashboard page.
    # It is part of the git repository and is committed every run-test.
    'increments.rb'
  end
  
  def visible_files_filename
    # Used to retrieve (via a single file access) the visible
    # files needed when resuming an animal.
    # It is part of the git repository and is committed every run-test.
    'manifest.rb'
  end

end


