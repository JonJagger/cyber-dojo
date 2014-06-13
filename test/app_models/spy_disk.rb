require File.dirname(__FILE__) + '/disk'
require File.dirname(__FILE__) + '/spy_dir'

class SpyDisk < Disk

  def teardown
    dirs.each { |_dir,spy| spy.teardown }
  end

  def make_dir(disk,path)
    SpyDir.new(disk,path)
  end

end
