
class Git

  def init(dir, args)
    if !File.directory?(dir)
      raise "Cannot `cd #{dir};git init` because #{dir} does not exist"
    end
    run(dir, 'init', args)
  end

  def add(dir, args)
    run(dir, 'add', quoted(args))
  end

  def rm(dir, args)
    run(dir, 'rm', quoted(args))
  end

  def commit(dir, args)
    c1 = run(dir, 'commit', args)
    c2 = run(dir, 'gc', '--aggressive --quiet')
    c1 + c2
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

  def quoted(args)
    "'" + args + "'"
  end

  def run(dir, command, args)
    `cd #{dir}; git #{command} #{args}`
  end

end