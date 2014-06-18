__DIR__ = File.dirname(__FILE__) + '/../../'

require __DIR__ + '/app/lib/Docker'
require __DIR__ + '/app/lib/DockerTestRunner'
require __DIR__ + '/app/lib/DummyTestRunner'
require __DIR__ + '/app/lib/HostTestRunner'
require __DIR__ + '/lib/Git'
require __DIR__ + '/lib/OsDisk'

class Dojo

  def initialize(path, format = 'json')
    @path,@format = path,format
    raise RuntimeError.new('format must be json|rb') if !['json','rb'].include?(format)
    raise RuntimeError.new("path must end in /") if !path.end_with?('/')
    thread = Thread.current
    thread[:disk]   ||= OsDisk.new
    thread[:git]    ||= Git.new
    thread[:runner] ||= runner
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

private

  def runner
    return DockerTestRunner.new if Docker.installed?
    return HostTestRunner.new   if ENV['CYBERDOJO_USE_HOST'] != nil
    return DummyTestRunner.new
  end

end
