
class DiskGit

  def init(dir, args)  
    run(dir, 'init', args)
  end
  
  def add(dir, args)
    run(dir, 'add', args)
  end

  def rm(dir, args)
    run(dir, 'rm', args)
  end
  
  def commit(dir, args)
    run(dir, 'commit', args)
    run(dir, 'gc', '--aggressive')
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

  def run(dir, command, args)
    `cd #{dir}; git #{command} #{args}`
  end
  
end