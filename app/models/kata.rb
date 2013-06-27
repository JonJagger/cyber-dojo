
require 'Files'
require 'DiskFile'

class Kata
  
  def self.create_new(root_dir, info)
    file = Thread.current[:file] || DiskFile.new
    file.write(Kata.new(root_dir, info[:id]).dir, 'manifest.rb', info)
  end
  
  def self.exists?(root_dir, id)
    file = Thread.current[:file] || DiskFile.new
    file.directory?(Kata.new(root_dir,id).dir)
  end

  #---------------------------------

  def initialize(root_dir, id)
    @root_dir = root_dir
    @id = Uuid.new(id)
    @file = Thread.current[:file] || DiskFile.new
  end
  
  def dir
    @root_dir + @file.separator +
      'katas'   + @file.separator +
        @id.inner + @file.separator +
          @id.outer    
  end

  def id
    @id.to_s
  end
    
  def avatars
    Avatar.names.select { |name|
      @file.exists?(dir, name)
    }.collect { |name|
      Avatar.new(self, name)
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
  
private

  def manifest
    eval @file.read(dir, 'manifest.rb')
  end
  
end
