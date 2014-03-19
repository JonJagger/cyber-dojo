
class LinuxPaas

  def initialize(disk, git, runner)
    @disk,@git,@runner = disk,git,runner
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def create_dojo(root, format)
    Dojo.new(self, root, format)
  end

  def make_kata(language, exercise, id, now)
    #TODO: don't like this. should be Kata.new(dojo,id) -> pass dojo in as extra 1st param
    kata = Kata.new(language.dojo, id)
    manifest = {
      :created => now,
      :id => id,
      :language => language.name,
      :exercise => exercise.name,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = exercise.instructions
    disk_make_dir(kata)
    disk_write(kata, kata.manifest_filename, manifest)
    kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # each() iteration

  def languages_each(languages)
    #dir(languages).entries.select do |name|
    #   means SpyDir needs each() .DONE
    #   now how to handle is_dir?

    pathed = path(languages)
    Dir.entries(pathed).select do |name|
      yield name if is_dir?(File.join(pathed, name))
    end
  end

  def exercises_each(exercises)
    pathed = path(exercises)
    Dir.entries(pathed).each do |name|
      yield name if is_dir?(File.join(pathed, name))
    end
  end

  def kata_exists?(kata)
    dir(kata).exists?
  end

  def katas_each(katas)
    pathed = path(katas)
    Dir.entries(pathed).each do |outer_dir|
      outer_path = File.join(pathed, outer_dir)
      if is_dir?(outer_path)
        Dir.entries(outer_path).each do |inner_dir|
          inner_path = File.join(outer_path, inner_dir)
          if is_dir?(inner_path)
            yield outer_dir + inner_dir
          end
        end
      end
    end
  end

  def avatars_each(kata)
    Dir.entries(path(kata)).each do |name|
      yield name if is_dir?(File.join(path(kata), name))
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def start_avatar(kata)
    avatar = nil
    started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = Avatar.names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names.shuffle[0]
      avatar = Avatar.new(kata,avatar_name)

      disk_make_dir(avatar)
      git_init(avatar, '--quiet')

      disk_write(avatar, avatar.visible_files_filename, kata.visible_files)
      git_add(avatar, avatar.visible_files_filename)

      disk_write(avatar, avatar.traffic_lights_filename, [ ])
      git_add(avatar, avatar.traffic_lights_filename)

      kata.visible_files.each do |filename,content|
        disk_write(avatar.sandbox, filename,content)
        git_add(avatar.sandbox, filename)
      end

      kata.language.support_filenames.each do |filename|
        old_name = path(kata.language) + filename
        new_name = path(avatar.sandbox) + filename
        @disk.symlink(old_name, new_name)
      end

      avatar.commit(tag=0)
    end
    avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # disk-helpers

  def disk_make_dir(object)
    dir(object).make
  end

  def disk_read(object, filename)
    dir(object).read(filename)
  end

  def disk_write(object, filename, content)
    dir(object).write(filename, content)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # git-helpers

  def git_init(object, args)
    @git.init(path(object), args)
  end

  def git_add(object, filename)
    @git.add(path(object), filename)
  end

  def git_rm(object, filename)
    @git.rm(path(object), filename)
  end

  def git_commit(object, args)
    @git.commit(path(object), args)
  end

  def git_tag(object, args)
    @git.tag(path(object), args)
  end

  def git_diff(object, args)
    @git.diff(path(object), args)
  end

  def git_show(object, args)
    @git.show(path(object), args)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # runner-helper

  def runner_run(object, command, max_duration)
    @runner.run(path(object), command, max_duration)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def dir(obj)
    @disk[path(obj)]
  end

  def path(obj)
    case obj
      when Languages
        root(obj) + 'languages/'
      when Language
        path(obj.dojo.languages) + obj.name + '/'
      when Exercises
        root(obj) + 'exercises/'
      when Exercise
        path(obj.dojo.exercises) + obj.name + '/'
      when Katas
        root(obj) + 'katas/'
      when Kata
        path(obj.dojo.katas) + obj.id[0..1] + '/' + obj.id[2..-1] + '/'
      when Avatar
        path(obj.kata) + obj.name + '/'
      when Sandbox
        path(obj.avatar) + 'sandbox/'
    end
  end

  def root(obj)
    obj.dojo.path
  end

private

  def is_dir?(name)
    File.directory?(name) && !name.end_with?('.') && !name.end_with?('..')
  end

end

