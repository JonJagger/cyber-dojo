
class SpyDir

  def initialize(spy_disk,dir)
    @spy_disk,@dir,@made,@files = spy_disk,dir,false,{}
  end

  def exists?(filename = "")
    @spy_disk.exists?(@dir, filename)
  end

  def make
    @spy_disk.make_dir(@dir)
  end

  def write(filename, content)
    @spy_disk.write(@dir,filename,content)
  end

  def read(filename)
    @spy_disk.read(@dir,filename)
  end

  def lock(&block)
    block.call
  end

  # - - - - - - - - - - - - - - -

  def spy_read(filename,content)
    @spy_disk.spy_read(@dir,filename,content)
  end

end
