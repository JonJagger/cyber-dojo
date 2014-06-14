require File.dirname(__FILE__) + '/Disk'
require File.dirname(__FILE__) + '/FakeDir'

class FakeDisk < Disk

  def make_dir(disk,path)
    FakeDir.new(disk,path)
  end

end
