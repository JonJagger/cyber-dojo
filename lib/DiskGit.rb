require 'Files'

class DiskGit

  def init(dir, options)  
    system("cd #{dir}; git init #{options}")
  end
  
  def add(dir, what)
    system("cd #{dir}; git add #{what}")
  end

  def commit(dir, options)
    system("cd #{dir}; git commit #{options}")
  end

  def tag(dir, options)
    system("cd #{dir}; git tag #{options}")
  end
  
  def show(dir, options)
    eval Files::popen_read("cd #{dir}; git show #{options}")
  end  
  
  def diff(dir, options)
    Files::popen_read("cd #{dir}; git diff #{options}")
  end
  
  def most_recent_tag(dir)
    eval Files::popen_read("cd #{dir}; git tag|sort -g")
  end

end