
class Kata

  def initialize(katas,id)
    raise "Invalid Kata(id)" if !katas.valid?(id)
    @katas,@id = katas,id
  end

  attr_reader :katas, :id

  def start_avatar(avatar_names = Avatars.names.shuffle)
    free_names = avatar_names - started_avatar_names
    if free_names != [ ]
      avatar = Avatar.new(self,free_names[0])
      avatar.start
    end
    avatar
  end

  def path
    katas.path + outer(id) + '/' + inner(id) + '/'
  end

  def exists?
    dir.exists?
  end

  def active?
    avatars.active.count > 0
  end

  def avatars
    Avatars.new(self)
  end

  def age(now = Time.now.to_a[0..5].reverse)
    return 0 if !active?
    return (Time.mktime(*now) - earliest_light).to_i
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

private

  include ExternalDiskDir
  include ExternalGit

  def manifest_property
    property_name = (caller[0] =~ /`([^']*)'/ and $1)
    manifest[property_name]
  end

  def manifest_filename
    'manifest.json'
  end
  
  def manifest
    @manifest ||= JSON.parse(dir.read(manifest_filename))
  end

  def earliest_light
    # time of first test
    Time.mktime(*avatars.active.map{ |avatar|
      avatar.lights[0].time
    }.sort[0])
  end

  def dojo
    katas.dojo
  end

  def outer(id)
    id[0..1]  # 'E5'
  end

  def inner(id)
    id[2..-1] # '6A3327FE'
  end

  def started_avatar_names
    avatars.each.collect { |avatar| avatar.name }
  end

end
