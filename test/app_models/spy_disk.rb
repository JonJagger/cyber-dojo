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
    return rdir != nil && (filename == "" || rdir[filename] != nil)
  end

  def read(dir, filename)
    @read_log[dir] ||= [ ]
    @read_log[dir] << [filename]

    if @read_repo[dir] == nil
      raise "SpyDisk:nil  read(#{dir},#{filename})"
    end

    @read_repo[dir][filename]
  end

  def write(dir, filename, object)
    @write_log[dir] ||= [ ]
    @write_log[dir] << [filename, object.inspect]

    make_dir(dir) #@read_repo[dir] ||= { }
    @read_repo[dir][filename] = object.inspect
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

end
