
class Git

  def init(dir, args)
    if !File.directory?(dir)
      raise "Cannot `cd #{dir};git init` because #{dir} does not exist"
    end
    run(dir, 'init', args)
  end

  def config(dir, args)
    run(dir, 'config', args)
  end

  def add(dir, args)
    run(dir, 'add', quoted(args))
  end

  def rm(dir, args)
    run(dir, 'rm', quoted(args))
  end

  def commit(dir, args)
    run(dir, 'commit', args)
  end

  def gc(dir, args)
    run(dir, 'gc', args)
  end

  def tag(dir, args)
    run(dir, 'tag', args)
  end

  def show(dir, args)
    run(dir, 'show', args)
  end

  def diff(dir, args)
    run(dir, 'diff', args)
  end

private

  include Cleaner

  def quoted(args)
    "'" + args + "'"
  end

  def run(dir, command, args)
    log = [ ]
    cd_cmd = "cd #{dir}"
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

end
