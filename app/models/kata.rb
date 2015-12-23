
class Kata

  def initialize(katas, id)
    # Does *not* validate id.
    # All access to kata object must come through dojo.katas[id]
    @katas = katas
    @id = id
  end

  # queries

  attr_reader :katas, :id

  def parent
    katas
  end

  def path
    katas.path + outer(id) + '/' + inner(id) + '/'
  end

  def avatars
    Avatars.new(self)
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
    languages[manifest_property]
  end

  def exercise
    exercises[manifest_property]
  end

  def manifest
    # This is a public method because when fork fails it reports
    # the name of language that could not be forked from.
    # kata.language.name will not work since name is based on
    # display_name which is required and comes from the manifest.json
    @manifest ||= read_json(manifest_filename)
  end

  # modifiers

  def start_avatar(avatar_names = Avatars.names.shuffle)
    avatar = nil
    avatar_name = starter.start_avatar(path, avatar_names)
    unless avatar_name.nil?
      avatar = Avatar.new(self, avatar_name)
      avatar.start
    end
    avatar
  end

  private

  include ExternalParentChainer
  include ExternalDir
  include ManifestProperty
  include IdSplitter

  def manifest_filename
    'manifest.json'
  end

  def earliest_light
    Time.mktime(*avatars.active.map { |avatar| avatar.lights[0].time }.sort[0])
  end

end
