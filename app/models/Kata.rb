
class Kata

  def initialize(dojo, id)
    @dojo,@id = dojo,id
  end

  attr_reader :dojo

  def format
    return 'json' if paas.exists?(self, manifest_prefix + 'json')
    return 'rb'   if paas.exists?(self, manifest_prefix + 'rb')
    return dojo.format
  end

  def exists?
    id.valid? && paas.exists?(self)
  end

  def active?
    active_avatars.count > 0
  end

  def expired?
    age > 60*60*24  # 1 day
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

  def active_avatars
    avatars.select{|avatar| avatar.active?}
  end

  def created
    Time.mktime(*manifest['created'])
  end

  def age(now = Time.now)
    return 0 if !active?
    # time of 1st manually pressed traffic-light
    earliest = active_avatars.map{|avatar| avatar.lights[1].time_stamp}.sort[0]
    return (now - Time.mktime(*earliest)).to_i
  end

  def visible_files
    manifest['visible_files']
  end

  def manifest_filename
    manifest_prefix + format
  end

  def manifest
    raw = paas.read(self, manifest_filename)
    text = raw.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
    return @manifest ||= JSON.parse(JSON.unparse(eval(text))) if format === 'rb'
    return @manifest ||= JSON.parse(text) if format === 'json'
  end

private

  def paas
    dojo.paas
  end

  def manifest_prefix
    'manifest.'
  end

end
