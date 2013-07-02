require File.dirname(__FILE__) + '/../test_helper'

class StubDiskFile
  
  def initialize
    @read_log = { }
    @write_log = { }
    @read_repo = { }
  end

  def read_log
    @read_log
  end
  
  def write_log
    @write_log
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

    @read_repo[dir][filename]
  end
  
  def write(dir, filename, object)
    @write_log[dir] ||= [ ]
    @write_log[dir] << [filename, object.inspect]    
  end
  
  def directory?(dir)
    @write_log[dir] != nil
  end
  
  def exists?(dir, filename = "")
    @write_log[dir] != nil
  end
  
end

