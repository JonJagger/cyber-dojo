
class Git

  def init(path, args)
    if !File.directory?(path)
      raise "Cannot `cd #{path};git init` because #{path} does not exist"
    end
    run(path, 'init', args)
  end

  def config(path, args)
    run(path, 'config', args)
  end

  def add(path, args)
    run(path, 'add', quoted(args))
  end

  def rm(path, args)
    run(path, 'rm', quoted(args))
  end

  def commit(path, args)
    run(path, 'commit', args)
  end

  def gc(path, args)
    run(path, 'gc', args)
  end

  def tag(path, args)
    run(path, 'tag', args)
  end

  def show(path, args)
    run(path, 'show', args)
  end

  def diff(path, args)
    run(path, 'diff', args)
  end

private

  include Cleaner

  def run(path, command, args)
    log = [ ]
    cd_cmd = "cd #{path}"
    git_cmd = "git #{command} #{args}"
    cmd = [cd_cmd,git_cmd].map{|s| stderr2stdout(s)}.join(shell_separator)
    IO.popen(cmd).each do |line|
      log << line
    end.close
    status = $?.exitstatus
    if status != success
      log << "cmd=#{cmd}"
      log << "$?.exitstatus=#{status}"
      log << "output=#{log}"
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
