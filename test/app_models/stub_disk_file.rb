require File.dirname(__FILE__) + '/../test_helper'

class StubDiskFile
  
  def initialize
    @read_log = { }
    @write_log = { }
    @symlink_log = [ ]
    @read_repo = { }
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
  
  def separator
    '/'
  end
  
  def read=(hash)
    dir = hash[:dir]
    filename = hash[:filename]
    content = hash[:content]
    @read_repo[dir] ||= { }
    @read_repo[dir][filename] = content
  end
  
  def read(dir, filename)
    @read_log[dir] ||= [ ]
    @read_log[dir] << [filename]

    if @read_repo[dir] == nil
      puts "stub_disk_file:nil  read(#{dir},#{filename})"
    end
    
    @read_repo[dir][filename]
  end
  
  def write(dir, filename, object)
    # TODO: using an array here is perhaps not such a good idea
    #       since I don't really want to test the order of writes...
    @write_log[dir] ||= [ ]
    @write_log[dir] << [filename, object.inspect]
    
    @read_repo[dir] ||= { }
    @read_repo[dir][filename] = object.inspect
  end
  
  def directory?(dir)
    @write_log[dir] != nil
  end
  
  def exists?(dir, filename = "")
    @write_log[dir] != nil
  end
  
  def lock(dir, &block)
    block.call()
  end
  
  def symlink(old_name, new_name)
    @symlink_log << ['symlink', old_name, new_name]    
  end
  
end

