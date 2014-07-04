require 'json'
require_relative '../lib/Cleaner'

class Kata

  def initialize(katas,id,externals)
    raise "Invalid Kata(id)" if !katas.valid?(id)
    @katas,@id,@externals = katas,id,externals
  end

  attr_reader :katas, :id

  def start_avatar(avatar_names = Avatar.names.shuffle)
    avatar = nil
    started_avatar_names = avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = avatar_names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names[0]
      avatar = Avatar.new(self,avatar_name,@externals)

      avatar.dir.make
      git.init(avatar.path, '--quiet')

      avatar.dir.write('manifest.json', visible_files)
      git.add(avatar.path, 'manifest.json')

      avatar.dir.write('increments.json', [ ])
      git.add(avatar.path, 'increments.json')

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
    #@katas.path + id.inner + '/' + id.outer + '/'
    @katas.path + inner(id) + '/' + outer(id) + '/'
  end

  def dir
    disk[path]
  end

  def exists?
    #id.valid? && dir.exists?
    dir.exists?
  end

  def active?
    avatars.active.count > 0
  end

  #def id
  #  Id.new(@id)
  #end

  def original_language
    # allow kata to be reviewed/forked even
    # if it's language name has changed
    # See app/models/language.rb ::new_name()
    dojo.languages[manifest['language']]
  end

  def language
    dojo.languages[original_language.new_name]
  end

  def original_exercise
    dojo.exercises[manifest['exercise']]
  end

  def exercise
    dojo.exercises[original_exercise.new_name]
  end

  def avatars
    Avatars.new(self, @externals)
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

  def manifest
    @manifest ||= JSON.parse(clean(dir.read('manifest.json')))
  end

private

  def disk
    @externals[:disk]
  end

  def git
    @externals[:git]
  end

  def earliest_light
    # time of first manually pressed traffic-light
    # (initial traffic-light is automatically created)
    Time.mktime(*avatars.active.map{|avatar| avatar.lights[1].time}.sort[0])
  end

  def dojo
    @katas.dojo
  end

  def inner(id)
    id[0..1]  # 'E5'
  end

  def outer(id)
    id[2..-1] # '6A3327FE'
  end

  include Cleaner

end
