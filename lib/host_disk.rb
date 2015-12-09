
#

class HostDisk

  def initialize(_dojo)
  end

  def dir?(name)
    File.directory?(name)
  end

  def [](name)
    HostDir.new(self, name)
  end

end
