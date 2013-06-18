
require 'Files'
require 'Folders'
require 'Uuid'

class Kata
  
  def self.create_new(root_dir, info)    
    Files::file_write(Kata.new(root_dir, info[:id]).dir + '/manifest.rb', info)
  end
  
  def self.exists?(root_dir, id)
    File.directory? Kata.new(root_dir,id).dir
  end

  #---------------------------------

  def initialize(root_dir, id)
    @root_dir = root_dir
    @id = Uuid.new(id)
  end
  
  def id
    @id.to_s
  end
    
  def avatars
    Avatar.names.select { |name|
      File.exists?(dir + '/' + name)
    }.collect { |name|
      Avatar.new(self,name)
    }
  end
  
  def language
    Language.new(@root_dir, manifest[:language])
  end
  
  def exercise
    Exercise.new(@root_dir, manifest[:exercise])
  end

  def visible_files
    manifest[:visible_files]
  end
      
  def created
    Time.mktime(*manifest[:created])
  end
  
  def age_in_seconds(now = Time.now)
    (now - created).to_i
  end
  
  def dir
    @root_dir + '/katas/' + @id.inner + '/' + @id.outer    
  end
  
private

  def manifest
    eval IO.read(dir + '/' + 'manifest.rb')
  end
  
end
