
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
    Kata.new(@dir,id)
  end
  
  def language(name)
    Language.new(@dir,name)
  end
  
  def exercise(name)
    Exercise.new(@dir,name)
  end

  def create_kata(info)
    file = Thread.current[:file] || DiskFile.new
    kata = Kata.new(dir, info[:id])
    file.write(kata.dir, 'manifest.rb', info)
    kata
  end

end
