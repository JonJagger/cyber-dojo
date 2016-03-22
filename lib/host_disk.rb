
#

class HostDisk

  def initialize(dojo)
    @parent = dojo
  end

  attr_reader :parent

  def dir?(name)
    File.directory?(name)
  end

  def [](name)
    HostDir.new(self, name)
  end

  private

  include ExternalParentChainer

end
