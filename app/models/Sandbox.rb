
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def path
    avatar.path + 'sandbox/'
  end

  def write(filename, content)
    paas.write(self, filename, content)
  end

private

  def paas
    avatar.kata.dojo.paas
  end

end
