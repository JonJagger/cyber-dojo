
class Kata

  def initialize(katas, id)
    # Does *not* validate id.
    # All access to kata object must come through dojo.katas[id]
    @katas = katas
    @id = id
  end

  # modifiers

  def start_avatar(avatar_names = Avatars.names.shuffle)
    name = history.kata_start_avatar(self, avatar_names)
    return nil if name.nil?
    Avatar.new(self, name)
  end

  # queries

  attr_reader :katas, :id

  def parent
    katas
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
    languages[language_name]
  end

  def exercise
    exercises[exercise_name]
  end

  def language_name
    # used in forker_controller
    manifest['language']
  end

  def exercise_name
    # used in forker_controller
    manifest['exercise']
  end

  private

  include ExternalParentChainer
  include ManifestProperty

  def manifest
    @manifest ||= history.kata_manifest(self)
  end

  def earliest_light
    Time.mktime(*avatars.active.map { |avatar| avatar.lights[0].time }.sort[0])
  end

end
