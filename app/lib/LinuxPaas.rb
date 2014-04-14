
class LinuxPaas

  def initialize(disk, git, runner)
    @disk,@git,@runner = disk,git,runner
  end

  def create_dojo(root, format)
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
    write(kata, kata.manifest_filename, manifest)
    kata
  end

  def start_avatar(kata, avatar_names)
    avatar = nil
    started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = avatar_names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names[0]
      avatar = Avatar.new(kata, avatar_name)

      make_dir(avatar)
      git_init(avatar, '--quiet')

      write(avatar, avatar.visible_files_filename, kata.visible_files)
      git_add(avatar, avatar.visible_files_filename)

      write(avatar, avatar.traffic_lights_filename, [ ])
      git_add(avatar, avatar.traffic_lights_filename)

      kata.visible_files.each do |filename,content|
        write(avatar.sandbox, filename,content)
        git_add(avatar.sandbox, filename)
      end

      kata.language.support_filenames.each do |filename|
        old_name = path(kata.language) + filename
        new_name = path(avatar.sandbox) + filename
        symlink(old_name, new_name)
      end

      avatar.commit(tag=0)
    end
    avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def exists?(object, filename='')
    dir(object).exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def languages_each(languages)
    pathed = path(languages)
    @disk[pathed].entries.select do |name|
      if @disk.is_dir?(File.join(pathed, name))
        yield name
      end
    end
  end

  def exercises_each(exercises)
    pathed = path(exercises)
    @disk[pathed].entries.select do |name|
      yield name if @disk.is_dir?(File.join(pathed, name))
    end
  end

  def katas_each(katas)
    pathed = path(katas)
    @disk[pathed].each do |outer_dir|
      outer_path = File.join(pathed, outer_dir)
      if @disk.is_dir?(outer_path)
        @disk[outer_path].each do |inner_dir|
          inner_path = File.join(outer_path, inner_dir)
          if @disk.is_dir?(inner_path)
            yield outer_dir + inner_dir
          end
        end
      end
    end
  end

  def avatars_each(kata)
    pathed = path(kata)
    @disk[pathed].entries.select do |name|
      yield name if @disk.is_dir?(File.join(pathed, name))
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def make_dir(object)
    dir(object).make
  end

  def read(object, filename)
    dir(object).read(filename)
  end

  def write(object, filename, content)
    dir(object).write(filename, content)
  end

  def symlink(old_name, new_name)
    @disk.symlink(old_name, new_name)
  end

  def dir(obj)
    @disk[path(obj)]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

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

  def runnable?(language)
    @runner.runnable?(language)
  end

  def runner_run(sandbox, command, max_duration)
    @runner.run(self, sandbox, command, max_duration)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def path(obj)
    case obj
      when Languages
        root(obj.dojo) + 'languages/'
      when Language
        path(obj.dojo.languages) + obj.name + '/'
      when Exercises
        root(obj.dojo) + 'exercises/'
      when Exercise
        path(obj.dojo.exercises) + obj.name + '/'
      when Katas
        root(obj.dojo) + 'katas/'
      when Kata
        path(obj.dojo.katas) + obj.id.inner + '/' + obj.id.outer + '/'
      when Avatar
        path(obj.kata) + obj.name + '/'
      when Sandbox
        path(obj.avatar) + 'sandbox/'
    end
  end

  def root(dojo)
    dojo.path
  end

end
