
class Kata

  def initialize(dojo, id)
    @dojo,@id = dojo,id
  end

  attr_reader :dojo

  def path
    dojo.katas.path + id.inner + '/' + id.outer + '/'
  end

  def exists?
    id.valid? && paas.exists?(self)
  end

  def active?
    avatars.active.count > 0
  end

  def id
    Id.new(@id)
  end

  def original_language
    # allow kata to be reviewed/forked even
    # if it's language name has changed
    # See app/models/language.rb ::new_name()
    dojo.languages[manifest['language']]
  end

  def language
    dojo.languages[original_language.new_name]
  end

  def exercise
    dojo.exercises[manifest['exercise']]
  end

  def start_avatar(names = Avatars.names.shuffle)
    paas.start_avatar(self, names)
  end

  def avatars
    Avatars.new(self)
  end

  def created
    Time.mktime(*manifest['created'])
  end

  def age(now = Time.now.to_a[0..5].reverse)
    return 0 if !active?
    return (Time.mktime(*now) - earliest_light).to_i
  end

  def visible_files
    manifest['visible_files']
  end

  def manifest_filename
    manifest_prefix + format
  end

  def manifest
    return @manifest ||= JSON.parse(JSON.unparse(eval(text))) if format === 'rb'
    return @manifest ||= JSON.parse(text) if format === 'json'
  end

  def format
    return 'json' if paas.exists?(self, manifest_prefix + 'json')
    return 'rb'   if paas.exists?(self, manifest_prefix + 'rb')
    return dojo.format
  end

private

  def paas
    dojo.paas
  end

  def manifest_prefix
    'manifest.'
  end

  def text
    raw = paas.read(self, manifest_filename)
    raw.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def earliest_light
    # time of first manually pressed traffic-light
    # (initial traffic-light is automatically created)
    Time.mktime(*avatars.active.map{|avatar| avatar.lights[1].time}.sort[0])
  end

end
