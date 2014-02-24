require File.dirname(__FILE__) + '/spy_dir'

class SpyDisk

  def initialize
    @read_log = { }
    @write_log = { }
    @symlink_log = [ ]
    @read_repo = { }
  end

  def dir_separator
    '/'
  end

  def [](dir)
    SpyDir.new(self,dir)
  end

  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]
  end

  #- - - - - - - - - - - -

  def make_dir(dir)
    @read_repo[dir] ||= { }
  end

  def exists?(dir, filename = "")
    rdir = @read_repo[dir]
    rdir != nil && (filename == "" || rdir[filename] != nil)
  end

  def read(dir, filename)
    @read_log[dir] ||= [ ]
    @read_log[dir] << [filename]
    assert @read_repo[dir] != nil, "read(#{dir},#{filename}) not primed"
    @read_repo[dir][filename]
  end

  def write(dir, filename, content)
    @write_log[dir] ||= [ ]
    make_dir(dir)
    if filename.end_with?(".rb")
      assert content.class != String, "write(#{dir},#{filename},content.class != String)"
      content = content.inspect
    end
    if filename.end_with?(".json")
      assert content.class != String, "write(#{dir},#{filename},content.class != String)"
      content = JSON.unparse(content)
    end
    @write_log[dir] << [filename, content]
    @read_repo[dir][filename] = content
  end

  def lock(dir, &block)
    block.call()
  end

  #- - - - - - - - - - - -

  def spy_read(dir,filename,content)
    make_dir(dir)
    @read_repo[dir][filename] = content
  end

  def read_log
    @read_log
  end

  def write_log
    @write_log
  end

  def symlink_log
    @symlink_log
  end

  def assert(truth, message)
    if !truth
      raise "SpyDisk.#{message}"
    end
  end

end
