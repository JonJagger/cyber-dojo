
class Dojo

  def initialize(path,format,externals)
    @path,@format = path,format
    @externals = externals
    raise RuntimeError.new('format must be json|rb') if !['json','rb'].include?(format)
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
    raise RuntimeError.new('disk not set') if externals[:disk].nil?
    raise RuntimeError.new('git not set') if externals[:git].nil?
    raise RuntimeError.new('runner not set') if externals[:runner].nil?
  end

  attr_reader :format

  def languages
    languages_path = @path + 'languages/'
    Languages.new(languages_path, @externals[:disk], @externals[:runner])
  end

  def exercises
    exercises_path = @path + 'exercises/'
    Exercises.new(exercises_path, @externals[:disk])
  end

  def katas
    katas_path = @path + 'katas/'
    Katas.new(self, katas_path, @externals)
  end

end
