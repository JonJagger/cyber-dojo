
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

  def make_kata_manifest(dojo, language, exercise, id, now)
    {
      :created => now,
      :id => id,
      :language => language.name,
      :exercise => exercise.name,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end

  def make_kata(dojo, language, exercise, id, now)
    manifest = make_kata_manifest(dojo, language, exercise, id, now)
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = exercise.instructions
    kata = Kata.new(dojo, id)
    kata.dir.write(kata.manifest_filename, manifest)
    kata
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

  #- - - - - - - - - - - - - - - - - - - - - - - -

  #def exists?(object, filename='')
  #  dir(object).exists?(filename)
  #end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  #def make_dir(object)
  #  dir(object).make
  #end

  #def read(object, filename)
  #  dir(object).read(filename)
  #end

  #def write(object, filename, content)
  #  dir(object).write(filename, content)
  #end

  #def symlink(from, to)
  #  @disk.symlink(from, to)
  #end

  #def dir(object)
  #  @disk[object.path]
  #end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  #def runnable?(language)
  #  @runner.runnable?(language)
  #end

end
