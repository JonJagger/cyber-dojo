require File.dirname(__FILE__) + '/../test_helper'

class StubDiskGit
  
  def initialize
    @log = { }
  end
  
  def log
    @log
  end
  
  def init(dir, options)
    store(dir, 'init', options)
  end
  
  def add(dir, what)
    store(dir, 'add', what)
  end
  
  def commit(dir, options)
    store(dir, 'commit', options)
  end
  
  def tag(dir, options)
    store(dir, 'commit', options)
  end
  
  def show(dir, options)
    store(dir, "show", options)
  end
  
private

  def store(dir, command, options)
    @log[dir] ||= [ ]
    @log[dir] << [command, options]
  end
    
end
