
class DiskGit

  def init(dir, args)  
    run(dir, 'init', args)
  end
  
  def add(dir, args)
    run(dir, 'add', quoted(args))
  end

  def rm(dir, args)
    run(dir, 'rm', quoted(args))
  end
  
  def commit(dir, args)
    run(dir, 'commit', args)
    run(dir, 'gc', '--aggressive --quiet')
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