
# Platform As A Service

class Paas

  def initialize(disk, git, runner)
    @disk,@git,@runner,@format = disk,git,runner,'json'
    thread = Thread.current
    thread[:disk]   ||= disk
    thread[:git]    ||= git
    thread[:runner] ||= runner
  end

  def format
    @format
  end

  def format_rb
    # only required when a test wants to create a paas
    # using old-style rb manifest files which are eval'd
    @format = 'rb'
  end

  def create_dojo(root)
    Dojo.new(self, root, format)
  end

  def start_avatar(kata, avatar_names)
    avatar = nil
    started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = avatar_names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names[0]
      avatar = Avatar.new(kata, avatar_name)

      avatar.dir.make
      @git.init(avatar.path, '--quiet')

      avatar.dir.write(avatar.visible_files_filename, kata.visible_files)
      @git.add(avatar.path, avatar.visible_files_filename)

      avatar.dir.write(avatar.traffic_lights_filename, [ ])
      @git.add(avatar.path, avatar.traffic_lights_filename)

      kata.visible_files.each do |filename,content|
        avatar.sandbox.dir.write(filename, content)
        @git.add(avatar.sandbox.path, filename)
      end

      kata.language.support_filenames.each do |filename|
        from = kata.language.path + filename
          to = avatar.sandbox.path + filename
        @disk.symlink(from, to)
      end

      avatar.commit(tag=0)
    end
    avatar
  end

end
