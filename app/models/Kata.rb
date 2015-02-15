
class Kata

  def initialize(katas,id)
    raise "Invalid Kata(id)" if !katas.valid?(id)
    @katas,@id = katas,id
  end

  attr_reader :katas, :id

  def start_avatar(avatar_names = Avatars.names.shuffle)
    started_avatar_names = avatars.each.collect { |avatar| avatar.name }
    free_avatar_names = avatar_names - started_avatar_names
    avatar = nil
    if free_avatar_names != [ ]
      avatar = Avatar.new(self,free_avatar_names[0])
      avatar.start

      visible_files.each do |filename,content|
        avatar.sandbox.write(filename, content)
        git.add(avatar.sandbox.path, filename)
      end

      language.support_filenames.each do |filename|
        from = language.path + filename
          to = avatar.sandbox.path + filename
        disk.symlink(from, to)
      end

      tag = 0
      avatar.commit(tag)
    end
    avatar
  end

  def path
    @katas.path + outer(id) + '/' + inner(id) + '/'
  end

  def exists?
    dir.exists?
  end

  def active?
    avatars.active.count > 0
  end

  def language
    dojo.languages[manifest['language']]
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

private

  include ExternalDiskDir
  include ExternalGit

  def manifest
    @manifest ||= JSON.parse(dir.read('manifest.json'))
  end

  def earliest_light
    # time of first test
    Time.mktime(*avatars.active.map{ |avatar|
      avatar.lights[0].time
    }.sort[0])
  end

  def dojo
    @katas.dojo
  end

  def outer(id)
    id[0..1]  # 'E5'
  end

  def inner(id)
    id[2..-1] # '6A3327FE'
  end

end
