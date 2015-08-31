# See comments at end of file

class Kata

  include ExternalParentChain
  
  def initialize(katas,id)
    raise "Invalid Kata(id)" if !katas.valid?(id)
    @parent,@id = katas,id
  end

  attr_reader :id

  def path
    @parent.path + outer(id) + '/' + inner(id) + '/'
  end

  def avatars
    Avatars.new(self)
  end

  def start_avatar(avatar_names = Avatars.names.shuffle)
    avatar = nil
    dir.lock do
      filename = 'started_avatars.json'
      started = dir.exists?(filename) ? JSON.parse(dir.read(filename)) : avatars.names
      free_names = avatar_names - started
      if free_names != [ ]
        avatar = Avatar.new(self, free_names[0])
        avatar.start
        if dir.exists?(filename)
          started << avatar.name
          dir.write(filename, started)
        end
        one_self.started(avatar)
      end
    end
    avatar
  end

  def exists?
    dir.exists?
  end

  def active?
    avatars.active.count > 0
  end

  def age(now = Time.now.to_a[0..5].reverse)
    return 0 if !active?
    return (Time.mktime(*now) - earliest_light).to_i
  end

  def finished?(now = Time.now.to_a[0..5].reverse)
    return false if !active?
    seconds_per_day = 60 * 60 * 24
    return age(now) >= seconds_per_day
  end
  
  def created
    Time.mktime(*manifest_property)
  end

  def visible_files
    manifest_property
  end

  def language
    dojo.languages[manifest_property]
  end

  def exercise
    dojo.exercises[manifest_property]
  end

  def manifest
    @manifest ||= JSON.parse(read(manifest_filename))
  end
  
private

  include ManifestProperty
  include IdSplitter

  def manifest_filename
    'manifest.json'
  end
  
  def read(filename)
    dir.read(filename)
  end
  
  def earliest_light
    Time.mktime(*avatars.active.map{ |avatar|
      avatar.lights[0].time
    }.sort[0])
  end

  def dojo
    @parent.dojo
  end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# manifest
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# This is a public method because when fork fails it reports
# the name of language that could not be forked from.
# kata.language.name will not work since name is based on
# display_name which is required and comes from the manifest.json
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
