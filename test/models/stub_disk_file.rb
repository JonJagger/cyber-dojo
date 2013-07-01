require File.dirname(__FILE__) + '/../test_helper'

class StubDiskFile
  
  def initialize
    @read_log = { }
    @write_log = { }
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
  
  def id
    '45ED23A2F1'
  end
  
  def kata_manifest
    {
      :id => id,
      :created => [2013,6,29,14,24,51],
      :unit_test_framework => 'verdal',
      :exercise => 'March Hare',
      :language => 'Carroll',
      :visible_files => {
        'name' => 'content for name'
      }
    }
  end
    
  def read(dir, filename)
    @read_log[dir] ||= [ ]
    @read_log[dir] << [filename]
    if filename == 'manifest.rb'
      return kata_manifest.inspect
    end
    return nil
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

