
class Dojo

  def initialize(path, format = 'json')
    @path,@format = path,format
    raise RuntimeError.new('format must be json|rb') if !['json','rb'].include?(format)
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')

    thread = Thread.current
    raise RuntimeError.new('External:git not set') if thread[:git].nil?
    raise RuntimeError.new('External:disk not set') if thread[:disk].nil?
    raise RuntimeError.new('External:runner not set') if thread[:runner].nil?
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
