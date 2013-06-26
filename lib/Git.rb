require 'Files'

module Git

  def self.init(dir, options)  
    system("cd #{dir}; git init #{options}")
  end
  
  def self.add(dir, what)
    system("cd #{dir}; git add #{what}")
  end

  def self.commit(dir, options)
    system("cd #{dir}; git commit #{options}")
  end

  def self.tag(dir, options)
    system("cd #{dir}; git tag #{options}")
  end
  
  def self.show(dir, options)
    eval Files::popen_read("cd #{dir}; git show #{options}")
  end  
  
  def self.diff(dir, options)
    Files::popen_read("cd #{dir}; git diff #{options}")
  end
  
  def self.most_recent_tag(dir)
    eval Files::popen_read("cd #{dir}; git tag|sort -g")
  end

end