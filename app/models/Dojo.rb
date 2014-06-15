
class Dojo

  def initialize(path, format)
    @path,@format = path,format
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
  end

  #TODO: aim to drop :path
  attr_reader :path, :format

  def languages
    Languages.new(@path + 'languages/')
  end

  def exercises
    Exercises.new(@path + 'exercises/')
  end

  def katas
    Katas.new(self)
  end

end
