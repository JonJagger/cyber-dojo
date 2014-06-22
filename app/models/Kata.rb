require 'Externals'

class Kata
  include Externals

  def initialize(katas, id)
    @katas,@id = katas,id
  end

  attr_reader :katas

  def start_avatar(avatar_names = Avatar.names.shuffle)
    avatar = nil
    started_avatar_names = avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = avatar_names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names[0]
      avatar = Avatar.new({:kata => self, :name => avatar_name})

      avatar.dir.make
      git.init(avatar.path, '--quiet')

      avatar.dir.write(avatar.visible_files_filename, visible_files)
      git.add(avatar.path, avatar.visible_files_filename)

      avatar.dir.write(avatar.traffic_lights_filename, [ ])
      git.add(avatar.path, avatar.traffic_lights_filename)

      visible_files.each do |filename,content|
        avatar.sandbox.dir.write(filename, content)
        git.add(avatar.sandbox.path, filename)
      end

      language.support_filenames.each do |filename|
        from = language.path + filename
          to = avatar.sandbox.path + filename
        disk.symlink(from, to)
      end

      avatar.commit(tag=0)
    end
    avatar
  end

  def path
    katas.path + id.inner + '/' + id.outer + '/'
  end

  def exists?
    id.valid? && dir.exists?
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
    return 'json' if dir.exists?(manifest_prefix + 'json')
    return 'rb'   if dir.exists?(manifest_prefix + 'rb')
    return dojo.format
  end

private

  def manifest_prefix
    'manifest.'
  end

  def text
    raw = dir.read(manifest_filename)
    raw.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def earliest_light
    # time of first manually pressed traffic-light
    # (initial traffic-light is automatically created)
    Time.mktime(*avatars.active.map{|avatar| avatar.lights[1].time}.sort[0])
  end

  def dojo
    katas.dojo
  end

end
