
require 'DiskFile'

class Kata
  
  # At the top level use either Kata.create or Kata.find

  def self.create(root_dir, info)
    file = Thread.current[:file] || DiskFile.new
    kata = Kata.new(root_dir, info[:id])
    file.write(kata.dir, 'manifest.rb', info)
    kata    
  end
  
  def self.find(root_dir, id)
    self.exists?(root_dir, id) ? Kata.new(root_dir, id) : nil
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
    @root_dir + separator +
      'katas'   + separator +
        @id.inner + separator +
          @id.outer    
  end

  def id
    @id.to_s
  end
    
  def start_avatar
    avatar = nil
    @file.lock(dir) do
      started_avatar_names = avatars.collect { |avatar| avatar.name }
      unstarted_avatar_names = Avatar.names - started_avatar_names
      if unstarted_avatar_names != [ ]
        avatar_name = random(unstarted_avatar_names)
        avatar = Avatar.create(self, avatar_name)
      end        
    end
    avatar
  end
  
  def avatars
    Avatar.names.map { |name|
      Avatar.new(self, name)
    }.select { |avatar|
      @file.exists? avatar.dir
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

  def random(array)
    array.shuffle[0]
  end

  def separator
    @file.separator
  end
  
  def manifest
    @manifest ||= eval @file.read(dir, 'manifest.rb')
  end
  
end
