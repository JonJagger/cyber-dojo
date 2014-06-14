
class Dojo

  def initialize(path, format)
    @path,@format = path,format
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
  end

  attr_reader :path, :format

  def languages
    Languages.new(self)
  end

  def exercises
    Exercises.new(self)
  end

  def katas
    Katas.new(self)
  end

end
