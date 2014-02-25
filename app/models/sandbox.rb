
require 'Git'
require 'TimeBoxedTask'

class Sandbox

  def initialize(avatar)
    @disk = Thread.current[:disk] || fatal
    @git  = Thread.current[:git]  || Git.new
    @task = Thread.current[:task] || TimeBoxedTask.new
    @avatar = avatar
  end

  def dir
    @disk[path]
  end

  def path
    @avatar.path + dir_separator + 'sandbox'
  end

  def test(delta, visible_files, max_duration = 15)
    delta[:changed].each do |filename|
      dir.write(filename, visible_files[filename])
    end
    delta[:new].each do |filename|
      dir.write(filename, visible_files[filename])
      @git.add(path, filename)
    end
    delta[:deleted].each do |filename|
      @git.rm(path, filename)
    end
    command  = "cd '#{dir.path}';" +
               "./cyber-dojo.sh"
    output = @task.execute(command, max_duration)
    # create output file so it appears in diff-view
    dir.write('output', output)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

private

  def fatal
    raise "no disk"
  end

  def dir_separator
    @disk.dir_separator
  end

end
