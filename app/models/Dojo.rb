
class Dojo

  def initialize(path, format)
    @path,@format = path,format
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
  end

  attr_reader :format

  def languages
    Languages.new(@path + 'languages/')
  end

  def exercises
    Exercises.new(@path + 'exercises/')
  end

  def katas
    Katas.new(self, @path + 'katas/')
  end

end
