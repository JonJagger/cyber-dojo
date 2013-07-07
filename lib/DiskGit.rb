
class DiskGit

  def init(dir, options)  
    system("cd #{dir}; git init #{options}")
  end
  
  def add(dir, what)
    system("cd #{dir}; git add #{what}")
  end

  def rm(dir, what)
    `cd #{dir}; git rm #{what}`
  end
  
  def commit(dir, options)
    system("cd #{dir}; git commit #{options}")
  end

  def tag(dir, options)
    system("cd #{dir}; git tag #{options}")
  end
  
  def show(dir, options)
    command = "cd #{dir}; git show #{options}"
    IO::popen(command).read
  end  
  
  def diff(dir, options)
    command = "cd #{dir}; git diff #{options}"
    IO::popen(command).read
  end
  
end