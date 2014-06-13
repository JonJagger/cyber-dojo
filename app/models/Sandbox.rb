require 'Externals'

class Sandbox
  include Externals

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def path
    avatar.path + 'sandbox/'
  end

  def write(filename, content)
    dir(path).write(filename, content)
  end

end
