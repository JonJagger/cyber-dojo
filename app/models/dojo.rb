
require 'DiskFile'

class Dojo
  
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

  def create_kata(manifest)
    file = Thread.current[:disk] || DiskFile.new
    kata = self[manifest[:id]]
    file.write(kata.dir, 'manifest.rb', manifest)
    kata
  end

end
