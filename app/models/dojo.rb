
class Dojo

  def initialize(path, format)
    @disk = Thread.current[:disk] || fatal("no disk")
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

  def fatal(diagnostic)
    raise diagnostic
  end

end
