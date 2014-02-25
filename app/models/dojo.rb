
class Dojo

  def initialize(path, format="rb")
    @disk = Thread.current[:disk] || fatal
    @path,@format = path,format
  end

  def path
    @path
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
    kata = self[manifest[:id]]
    kata.dir.write('manifest.' + @format, manifest)
    kata
  end

private

  def fatal
    raise "no disk"
  end

end
