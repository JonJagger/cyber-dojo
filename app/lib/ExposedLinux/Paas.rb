
module ExposedLinux

  class Paas

    def initialize(disk)
      @disk = disk
    end

    attr_reader :disk

    def create_dojo(root,format)
      Dojo.new(self,root,format)
    end

    def languages_each(languages)
      Dir.entries(languages.path).select do |name|
        yield name if is_dir?(File.join(languages.path,name))
      end
    end

    def exercises_each(exercises)
      Dir.entries(exercises.path).each do |name|
        yield name if is_dir?(File.join(exercises.path,name))
      end
    end

    def make_kata(language,exercise)
      manifest = {
        :created => make_time(Time.now),
        :id => Uuid.new.to_s,
        :language => language.name,
        :exercise => exercise.name, # used only for display
        :unit_test_framework => language.unit_test_framework,
        :tab_size => language.tab_size
      }
      manifest[:visible_files] = language.visible_files
      manifest[:visible_files]['output'] = ''
      manifest[:visible_files]['instructions'] = exercise.instructions
      kata = Kata.new(language.dojo,manifest[:id])
      @disk[kata.path].write('manifest.' + language.dojo.format, manifest)
      kata
    end

    def katas_each(dojo)
      pathed = Katas.new(dojo).path
      Dir.entries(pathed).each do |outer_dir|
        outer_path = File.join(pathed,outer_dir)
        if is_dir?(outer_path)
          Dir.entries(outer_path).each do |inner_dir|
            inner_path = File.join(outer_path,inner_dir)
            yield outer_dir+inner_dir if is_dir?(inner_path)
          end
        end
      end
    end

    def start_avatar(kata)
      #
      #  def kata.start_avatar
      #    avatar = nil
      #    dir.lock do
      #      started_avatar_names = avatars.collect { |avatar| avatar.name }
      #      unstarted_avatar_names = Avatar.names - started_avatar_names
      #      if unstarted_avatar_names != [ ]
      #        avatar_name = random(unstarted_avatar_names)
      #        avatar = self[avatar_name]
      #        avatar.setup
      #      end
      #    end
      #    avatar
      #  end
      #
      #  def avatar.setup
      #    @disk[path].make
      #    @git.init(path, "--quiet")
      #
      #    dir.write(visible_files_filename, @kata.visible_files)
      #    @git.add(path, visible_files_filename)
      #
      #    dir.write(traffic_lights_filename, [ ])
      #    @git.add(path, traffic_lights_filename)
      #
      #    @kata.visible_files.each do |filename,content|
      #      sandbox.dir.write(filename, content)
      #      @git.add(sandbox.path, filename)
      #    end
      #
      #    @kata.language.support_filenames.each do |filename|
      #      old_name = @kata.language.path + filename
      #      new_name = sandbox.path + filename
      #      @disk.symlink(old_name, new_name)
      #    end
      #
      #    git_commit(tag = 0)
      #  end

      Avatar.new(self,'lion')
    end

    def avatars_each(kata)
      Dir.entries(kata.path).each do |name|
        yield name if is_dir?(File.join(kata.path,name))
      end
    end

    def avatar_save(avatar,delta,visible_files)
      #...
    end

    def avatar_test(avatar)
      #...returns output
    end

    def avatar_visible_files(avatar,tag)
      #...
    end

    def avatar_traffic_lights(avatar,tag)
      #...
    end

  private

    def is_dir?(name)
      File.directory?(name) && !name.end_with?('.') && !name.end_with?('..')
    end

    def make_time(now)
      [now.year, now.month, now.day, now.hour, now.min, now.sec]
    end

  end

end

# idea is that this will hold methods that forward to external
# services namely: disk, git, shell.
# And I will create another implementation IsolatedDockerPaas
# Design notes
#
# o) IsolatedDockerPaas.disk will have smarts to know if reads/writes
#    are local to disk (eg exercises) or need to go into container.
#    ExposedLinuxPaas.disk can have several dojos (different root-dirs eg testing)
#    so parent refs need to link back to dojo which
#    will be used by paas to determine paths.
#
# o) in controller I can see if IsolatedDockerPaas is available and if it is
#    use that, otherwise drop back to using ExposedLinuxPaas
#
# o) each model will not expose a dir method. Instead I will
#    access the dirs off the paas.disk object.
#
# o) how will IsolatedDockerPaas know a languages'
#    initial visible_files? use same manifest format?
#    seems reasonable. Could even repeat the languages subfolder
#    pattern. No reason a Docker container could not support
#    several variations of language/unit-test.
#       - the docker container could have ruby code installed to
#         initialize an avatar from a language. All internally.
#         would save many docker run calls. Optimization.
#
# o) tests could be passed a paas object which they will use
#    idea is to repeat same test for several paas objects
#    eg one that spies completely
#    eg one that uses ExposedLinuxPaas
#    eg one that uses IsolatedDockerPaas
