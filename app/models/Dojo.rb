
class Dojo

  def initialize(paas, path, format)
    @paas,@path,@format = paas,path,format
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
  end

  attr_reader :paas, :path, :format

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
