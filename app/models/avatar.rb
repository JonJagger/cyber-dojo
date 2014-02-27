
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

  def initialize(kata, name)
    @disk = Thread.current[:disk] || fatal("no disk")
    @git = Thread.current[:git] || fatal("no git")
    @kata,@name = kata,name
  end

  def kata
    @kata
  end

  def name
    @name
  end

  def path
    @kata.path + name + @disk.dir_separator
  end

  def dir
    @disk[path]
  end

  def exists?
    dir.exists?
  end

  def setup
    @disk[path].make
    @git.init(path, "--quiet")

    dir.write(visible_files_filename, @kata.visible_files)
    @git.add(path, visible_files_filename)

    dir.write(traffic_lights_filename, [ ])
    @git.add(path, traffic_lights_filename)

    @kata.visible_files.each do |filename,content|
      sandbox.dir.write(filename, content)
      @git.add(sandbox.path, filename)
    end

    @kata.language.support_filenames.each do |filename|
      old_name = @kata.language.path + filename
      new_name = sandbox.path + filename
      @disk.symlink(old_name, new_name)
    end

    git_commit(tag = 0)
  end

  def save_run_tests(visible_files, traffic_light)
    traffic_lights = nil
    dir.lock do
      dir.write(visible_files_filename, visible_files)
      text = dir.read(traffic_lights_filename)
      traffic_lights = JSON.parse(JSON.unparse(eval text))
      traffic_lights << traffic_light
      traffic_light['number'] = traffic_lights.length
      dir.write(traffic_lights_filename, traffic_lights)
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
    output = @git.diff(path, command)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def sandbox
    Sandbox.new(self)
  end

  def git_commit(tag)
    # the -a is important for .txt files in approval style tests
    @git.commit(path, "-a -m '#{tag}' --quiet")
    @git.tag(path, "-m '#{tag}' #{tag} HEAD")
  end

private

  def fatal(diagnostic)
    raise diagnostic
  end

  def unlocked_read(filename, tag)
    dir.lock {
      locked_read(filename, tag)
    }
  end

  def locked_read(filename, tag)
    if tag != nil
      @git.show(path, "#{tag}:#{filename}")
    else
      dir.read(filename)
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
