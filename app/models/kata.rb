
require 'Disk'

class Kata

  def initialize(dojo, id)
    @disk = Thread.current[:disk] || Disk.new
    @dojo = dojo
    @id = Uuid.new(id)
  end

  def exists?
    @disk[dir].exists?
  end

  def dir
    @dojo.dir + dir_separator +
      'katas'   + dir_separator +
        @id.inner + dir_separator +
          @id.outer
  end

  def id
    @id.to_s
  end

  def [](avatar_name)
    Avatar.new(self,avatar_name)
  end

  def start_avatar
    avatar = nil
    @disk[dir].lock do
      started_avatar_names = avatars.collect { |avatar| avatar.name }
      unstarted_avatar_names = Avatar.names - started_avatar_names
      if unstarted_avatar_names != [ ]
        avatar_name = random(unstarted_avatar_names)
        avatar = self[avatar_name]
        avatar.setup
      end
    end
    avatar
  end

  def avatars
    Avatar.names.map{ |name| self[name] }.select { |avatar| avatar.exists? }
  end

  def language
    @dojo.language(manifest[:language])
  end

  def exercise
    @dojo.exercise(manifest[:exercise])
  end

  def visible_files
    manifest[:visible_files]
  end

  def created
    Time.mktime(*manifest[:created])
  end

  def age_in_seconds(now = Time.now)
    (now - created).to_i
  end

  def manifest_filename
    new_name = 'manifest.json'
    old_name = 'manifest.rb'
    @disk[dir].exists?(new_name) ? new_name : old_name
  end

private

  def dir_separator
    @disk.dir_separator
  end

  def random(array)
    array.shuffle[0]
  end

  def manifest
    @manifest ||= eval @disk[dir].read(manifest_filename)
  end

end
