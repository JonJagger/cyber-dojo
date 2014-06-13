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

  def dir
    disk[path]
  end

  def write(filename, content)
    dir.write(filename, content)
  end

end
