
class Kata
  extend Forwardable

  def initialize(dojo, id)
    @dojo,@id = dojo,id
  end

  attr_reader :dojo, :id

  def_delegators :dojo, :format, :format_is_rb?, :format_is_json?

  def exists?
    paas.kata_exists?(self)
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
    'manifest.' + dojo.format
  end

  def manifest
    text = paas.disk_read(self, manifest_filename)
    return @manifest ||= JSON.parse(JSON.unparse(eval(text))) if format_is_rb?
    return @manifest ||= JSON.parse(text) if format_is_json?
  end

private

  def paas
    dojo.paas
  end

end
