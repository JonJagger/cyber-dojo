
# can't call it CyberDojo presumably because something else
# is already called that from the rails app name

require 'DiskFile'

class Cyber_Dojo
  
  def initialize(dir)
    @dir = dir
  end

  def dir
    @dir
  end
  
  def [](id)
    Kata.new(self,id)
  end
  
  def language(name)
    Language.new(self,name)
  end
  
  def exercise(name)
    Exercise.new(self,name)
  end

  def create_kata(info)
    file = Thread.current[:file] || DiskFile.new
    kata = self[info[:id]]
    file.write(kata.dir, 'manifest.rb', info)
    kata
  end

end
