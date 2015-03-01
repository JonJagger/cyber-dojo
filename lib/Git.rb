
class Git

  def init(path, args)
    if !File.directory?(path)
      raise "Cannot `cd #{path};git init` because #{path} does not exist"
    end
    cd_run(path, 'init', args)
  end

  def config(path, args)
    cd_run(path, 'config', args)
  end

  def add(path, args)
    cd_run(path, 'add', quoted(args))
  end

  def rm(path, args)
    cd_run(path, 'rm', quoted(args))
  end

  def commit(path, args)
    cd_run(path, 'commit', args)
  end

  def gc(path, args)
    cd_run(path, 'gc', args)
  end

  def tag(path, args)
    cd_run(path, 'tag', args)
  end

  def show(path, args)
    cd_run(path, 'show', args)
  end

  def diff(path, args)
    cd_run(path, 'diff', args)
  end

private

  include Cleaner

  def cd_run(path, command, args)
    cd_cmd = "cd #{path}"
    git_cmd = "git #{command} #{args}"
    cmds = [cd_cmd,git_cmd].map{ |cmd| stderr2stdout(cmd) }.join(shell_separator)
    log = [ ]
    IO.popen(cmds).each{ |line| log << line }.close
    status = $?.exitstatus
    if status != success
      log = [ cmds ] << "FAILURE: $?.exitstatus=#{status}"
    end
    clean(log.join(''))
  end

  def stderr2stdout(cmd)
    cmd + ' ' + '2>&1'
  end

  def shell_separator
    ';'
  end

  def success
    0
  end

  def quoted(args)
    "'" + args + "'"
  end

end
