
class Dojo

  def initialize(path, format)
    @path,@format = path,format
    raise RuntimeError.new('format must be json|rb') if !['json','rb'].include?(format)
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')

    raise RuntimeError.new('disk not set') if thread[:disk].nil?
    raise RuntimeError.new('git not set') if thread[:git].nil?
    raise RuntimeError.new('runner not set') if thread[:runner].nil?
  end

  attr_reader :format

  def languages
    Languages.new(@path + 'languages/', externals[:disk], externals[:runner])
  end

  def exercises
    Exercises.new(@path + 'exercises/', externals[:disk])
  end

  def katas
    Katas.new(self, @path + 'katas/', externals)
  end

private

  def externals
    {
      :disk   => thread[:disk],
      :git    => thread[:git],
      :runner => thread[:runner]
    }
  end

  def thread
    Thread.current
  end

end
