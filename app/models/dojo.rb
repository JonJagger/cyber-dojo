
require 'Disk'

class Dojo

  def initialize(dir, format="rb")
    @dir,@format = dir,format
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
    disk = Thread.current[:disk] || Disk.new
    kata = self[manifest[:id]]
    disk[kata.dir].write('manifest.' + @format, manifest)
    kata
  end

end
