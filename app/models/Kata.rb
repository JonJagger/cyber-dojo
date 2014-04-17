
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

  def format_is_rb?
    format === 'rb'
  end

  def format_is_json?
    format === 'json'
  end

  def exists?
    paas.exists?(self)
  end

  def id
    Id.new(@id)
  end

  def language
    dojo.languages[manifest['language']]
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

  def visible_files
    manifest['visible_files']
  end

  def manifest_filename
    manifest_prefix + format
  end

  def manifest
    text = paas.read(self, manifest_filename)
    return @manifest ||= JSON.parse(JSON.unparse(eval(text))) if format_is_rb?
    return @manifest ||= JSON.parse(text) if format_is_json?
  end

private

  def paas
    dojo.paas
  end

  def manifest_prefix
    'manifest.'
  end

end
