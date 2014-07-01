
class Sandbox

  def initialize(avatar,disk)
    @avatar,@disk = avatar,disk
  end

  attr_reader :avatar

  def path
    avatar.path + 'sandbox/'
  end

  def dir
    @disk[path]
  end

  def write(filename, content)
    dir.write(filename, content)
  end

end
