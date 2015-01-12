
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def write(filename, content)
    dir.write(filename, content)
  end

  def path
    avatar.path + 'sandbox/'
  end

private

  include ExternalGetter

end
