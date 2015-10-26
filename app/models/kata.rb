# See comments at end of file

class Kata

  def initialize(katas, id)
    # Does *not* validate id. All access to kata object must come through katas[id]
    @parent = katas
    @id = id
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
      started = exists?(filename) ? read_json(filename) : started_avatars_names
      free_names = avatar_names - started
      if free_names != []
        avatar = Avatar.new(self, free_names[0])
        avatar.start
        write_json(filename, started << avatar.name)
      end
    end
    avatar
  end

  def active?
    avatars.active.count > 0
  end

  def age(now = Time.now.to_a[0..5].reverse)
    return 0 unless active?
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

  def manifest
    @manifest ||= read_json(manifest_filename)
  end

  private

  include ExternalParentChain
  include ManifestProperty
  include IdSplitter

  def manifest_filename
    'manifest.json'
  end

  def earliest_light
    Time.mktime(*avatars.active.map { |avatar| avatar.lights[0].time }.sort[0])
  end

  def dojo
    @parent.dojo
  end

  def started_avatars_names
    # Can't use avatars.names in start_avatar(), above, which does a dir.lock,
    # since avatars.name also does a dir.lock and dir.locks are not recursive.
    names = []
    Avatars.names.each do |name|
      names << name if disk[Avatar.new(self, name).path].exists?
    end
    names
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
