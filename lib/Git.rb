require 'Files'

module Git
  
  def self.show(dir, command)
    eval Files::popen_read("cd #{dir};git show #{command}")
  end  
  
  def self.diff(dir, command)
    Files::popen_read("cd #{dir};git diff #{command}")
  end
  
  def self.most_recent_tag(dir)
    eval Files::popen_read("cd #{dir};" + "git tag|sort -g")
  end

end