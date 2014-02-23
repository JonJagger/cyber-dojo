
class SpyDir

  def initialize(spy_disk,dir)
    @spy_disk,@dir,@made,@files = spy_disk,dir,false,{}
  end

  def exists?
    @spy_disk.exists?(@dir)
  end

  def make
    @spy_disk[@dir] = true
  end

  def read(filename)
    @spy_disk.read(@dir,filename)
  end

  def spy_read(filename,content)
    @spy_disk[@dir,filename] = content
  end

  def write(filename, content)
    @spy_disk.write(@dir,filename,content)
  end

  def lock(&block)
    block.call
  end

end
