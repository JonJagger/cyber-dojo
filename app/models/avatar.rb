
require 'Disk'
require 'Git'

class Avatar

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
    @git = Thread.current[:git] || Git.new
    @kata = kata
    @name = name
  end

  def exists?
    @disk[dir].exists?
  end

  def dir
    @kata.dir + dir_separator + name
  end

  def setup
    @disk[dir + '/'].make
    @git.init(dir, "--quiet")

    @disk[dir].write(visible_files_filename, @kata.visible_files)
    @git.add(dir, visible_files_filename)

    @disk[dir].write(traffic_lights_filename, [ ])
    @git.add(dir, traffic_lights_filename)

    @kata.visible_files.each do |filename,content|
      @disk[sandbox.dir].write(filename, content)
      @git.add(sandbox.dir, filename)
    end

    @kata.language.support_filenames.each do |filename|
      old_name = @kata.language.dir + dir_separator + filename
      new_name = sandbox.dir + dir_separator + filename
      @disk.symlink(old_name, new_name)
    end

    git_commit(tag = 0)
  end

  def kata
    @kata
  end

  def name
    @name
  end

  def save_run_tests(visible_files, traffic_light)
    traffic_lights = nil
    @disk[dir].lock do
      text = @disk[dir].read(traffic_lights_filename)
      traffic_lights = JSON.parse(JSON.unparse(eval text))
      traffic_lights << traffic_light
      tag = traffic_lights.length
      traffic_light['number'] = tag
      @disk[dir].write(traffic_lights_filename, traffic_lights)
      @disk[dir].write(visible_files_filename, visible_files)
      git_commit(tag)
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

  def dir_separator
    @disk.dir_separator
  end

  def git_commit(tag)
    # the -a is important for .txt files in approval style tests
    @git.commit(dir, "-a -m '#{tag}' --quiet")
    @git.tag(dir, "-m '#{tag}' #{tag} HEAD")
  end

  def unlocked_read(filename, tag)
    @disk[dir].lock {
      locked_read(filename, tag)
    }
  end

  def locked_read(filename, tag)
    if tag != nil
      @git.show(dir, "#{tag}:#{filename}")
    else
      @disk[dir].read(filename)
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
