require File.dirname(__FILE__) + '/Disk'
require File.dirname(__FILE__) + '/SpyDir'

class SpyDisk < Disk

  def teardown
    dirs.each_value { |spy| spy.teardown }
  end

  def make_dir(disk,path)
    SpyDir.new(disk,path)
  end

end
