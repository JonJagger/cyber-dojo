require_relative 'Disk'
require_relative 'FakeDir'

class FakeDisk
  include Disk

  def make_dir(disk,path)
    FakeDir.new(disk,path)
  end

end
