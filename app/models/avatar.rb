
require 'DiskFile'
require 'DiskGit'
require 'JSON'

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
    # Call this to create an object representing an
    # animal which has already started a kata
    @kata = kata
    @name = name
    @file = Thread.current[:file] || DiskFile.new
    @git = Thread.current[:git] || DiskGit.new
  end
  
  def setup
    @file.write(dir, Visible_files_filename, @kata.visible_files)
    @file.write(dir, Traffic_lights_filename, [ ])
    sandbox.save(@kata.visible_files) # includes output and instructions
    language = @kata.language
    sandbox.link(language.dir, language.support_filenames)
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
      text = @file.read(dir, Traffic_lights_filename)
      traffic_lights = JSON.parse(JSON.unparse(eval text)) 
      traffic_lights << traffic_light
      tag = traffic_lights.length
      traffic_light['number'] = tag
      @file.write(dir, Traffic_lights_filename, traffic_lights)
      @file.write(dir, Visible_files_filename, visible_files)
      git_commit(visible_files, tag)
    end
    traffic_lights
  end

  def visible_files(tag = nil)
    text = unlocked_read(Visible_files_filename, tag)
    JSON.parse(JSON.unparse(eval text))
  end
  
  def traffic_lights(tag = nil)
    text = unlocked_read(Traffic_lights_filename, tag)    
    JSON.parse(JSON.unparse(eval text))    
  end

  def diff_lines(was_tag, now_tag)
    # N.B. visible_files are saved to the sandbox dir individually.
    command = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    output = @git.diff(dir, command)
    # During the Chennai Cisco training 31 July 2013 I got a server-error when
    # trying to view a diff. The server log contained this...
    # Completed 500 Internal Server Error in 56ms
    #  
    # ArgumentError (invalid byte sequence in UTF-8):
    #   lib/LineSplitter.rb:23:in `split'
    #   lib/LineSplitter.rb:23:in `line_split'
    #   lib/GitDiffParser.rb:12:in `initialize'
    #   lib/GitDiff.rb:16:in `new'
    #   lib/GitDiff.rb:16:in `git_diff_view'
    #   app/controllers/diff_controller.rb:12:in `show'
    #
    # This is the same issue as in sandbox.test() so same fix
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)        
  end
  
  def sandbox
    Sandbox.new(self)
  end
  
private

  def git_commit(visible_files, tag)
    visible_files.keys.each do |filename|
      @git.add(dir, "sandbox/#{filename}")
    end
    # N.B. the -a is important for .txt files in approval style tests
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


