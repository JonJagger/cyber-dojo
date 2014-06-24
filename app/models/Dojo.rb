
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
    root_path = @path + 'languages/'
    Languages.new(root_path, @externals[:disk], @externals[:runner])
  end

  def exercises
    root_path = @path + 'exercises/'
    Exercises.new(root_path, @externals[:disk])
  end

  def katas
    root_path = @path + 'katas/'
    Katas.new(self, root_path, @externals)
  end

end
