
require 'DiskFile'

class Kata
  
  def initialize(dojo, id)
    @file = Thread.current[:disk] || DiskFile.new
    @dojo = dojo
    @id = Uuid.new(id)
  end
  
  def exists?
    @file.exists?(dir)
  end
  
  def dir
    @dojo.dir + separator +
      'katas'   + separator +
        @id.inner + separator +
          @id.outer    
  end

  def id
    @id.to_s
  end
    
  def [](avatar_name)
    Avatar.new(self,avatar_name)
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
    Avatar.names.map{ |name| self[name] }.select { |avatar| avatar.exists? }
  end
  
  def language
    @dojo.language(manifest[:language])
  end
  
  def exercise
    @dojo.exercise(manifest[:exercise])
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
