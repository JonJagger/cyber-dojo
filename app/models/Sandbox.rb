
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def write(filename, content)
    paas.write(self, filename, content)
  end

private

  def paas
    avatar.kata.dojo.paas
  end

end
