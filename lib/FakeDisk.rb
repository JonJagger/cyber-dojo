require 'Disk'
require 'FakeDir'

class FakeDisk < Disk

  def make_dir(disk,path)
    FakeDir.new(disk,path)
  end

end
