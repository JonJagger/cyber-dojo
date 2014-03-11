
module Docker

  class Paas

    def initialize(disk, git, runner)
      @disk,@git,@runner = disk,git,runner
      @cids = [ ]
      # at end of docker-transaction
      #   all cids inside @cids need to be deleted
      #   that means images and containers
      #   None of them should start with 'kata_' or 'avatar_'
    end

    #- - - - - - - - - - - - - - - - - - - - - - - -

    def create_dojo(root, format)
      Dojo.new(self, root, format)
    end

    #- - - - - - - - - - - - - - - - - - - - - - - -

    def make_kata(language, exercise, id, now)
      # this will need to find the image for the language
      # language image will have familiar folder structure...
      #    ~/cyber-dojo/languages/NAME/manifest.json
      #    ~/cyber-dojo/languages/NAME/cyber-dojo.sh
      #

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

      # write the manifest file to the language-image
      # commit the new container with a name
      #      kata_#{id}
      # don't put container's id into @cids
      #
      #     paas.disk_make_dir(kata)
      #     paas.disk_write(kata, kata.manifest_filename, manifest)

      kata
    end

    #- - - - - - - - - - - - - - - - - - - - - - - -
    # each() iteration

    def languages_each(languages)
      # iterate through a docker languages-registry
    end

    def exercises_each(exercises)
      # could stay on local disk?
      Dir.entries(path(exercises)).each do |name|
        yield name if is_dir?(File.join(path(exercises), name))
      end
    end

    def katas_each(katas)
      # iterate through docker katas-registry for katas
      # txt = `sudo docker images`
      # need to iterate and parse txt and yield TAG?
    end

    def avatars_each(kata)
      # iterate through docker katas-registry for avatars in kata
      # txt = `sudo docker images`
    end

    #- - - - - - - - - - - - - - - - - - - - - - - -

    def start_avatar(kata)
      # image = 'kata_' + kata.id

      avatar = nil
      started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
      unstarted_avatar_names = Avatar.names - started_avatar_names
      if unstarted_avatar_names != [ ]
        avatar_name = unstarted_avatar_names.shuffle[0]
        avatar = Avatar.new(kata,avatar_name)

        # write avatar-dir on kata-image to create new container-id
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
      # commit final container as 'avatar_' + kata.id + '_' + avatar.name + '_0'
      avatar
    end

    #- - - - - - - - - - - - - - - - - - - - - - - -

    def cidfile(object)
       # needs to be kata.id+avatar.name specific and local
      'docker.cid'
    end

    def docker(object, command)
      image = @cids.last
      `rm  -f #{cidfile}`
      result = `sudo docker run -cidfile="#{cidfile(object)}" -i #{image} /bin/bash -c "#{command}"`
      cid = `cat #{cidfile(object)}`
      `sudo docker commit #{cid} #{cid}`
      @cids << cid
      result
    end

    #- - - - - - - - - - - - - - - - - - - - - - - -
    # disk-helpers

    def disk_make_dir(object)
      #dir(object).make
      #
      #make dir in avatars-current-container-image
      #save created container-id ready for next docker-command in this transaction
    end

    def disk_read(object, filename)
      ########## dir(object).read(filename)
      # cids = [ 'base' ]  # base will need to be current-image for kata-avatar
      docker(object, "cat '#{filename}'")
    end

    def disk_write(object, filename, content)
      ####### dir(object).write(filename, content)

      # cids = [ 'base' ]  # base will need to be current-image for kata-avatar

      # image = @cids.last
      # cidfile = 'docker.cid'   # needs to be kata.id+avatar.name specific
      # `rm  -f #{cidfile}
      # filename = ??????  # needs appropriate dirname prefix?
      # `echo '#{content}' | sudo docker run -cidfile="#{cidfile}" -i #{image} /bin/bash -c "cat > '#{filename}'"`
      # cid = `cat #{cidfile}`
      # `sudo docker commit #{cid} #{cid}`
      # @cids << cid

      # if I cat to a file in a new dir will the folder be created? NO
      # so I need a command to create the dir first.

    end

    #- - - - - - - - - - - - - - - - - - - - - - - -
    # git-helpers
    # object always avatar or avatar.sandbox

    def git_init(object, args)
      # @git.init(path(object), args)
      #
      # dir = path(object)
      # cmd = 'init'
      docker(object, 'cd #{dir}; git {cmd} #{args}')
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
        when ExposedLinux::Languages
          obj.dojo.path + 'languages/'
        when ExposedLinux::Language
          path(obj.dojo.languages) + obj.name + '/'
        when ExposedLinux::Exercises
          obj.dojo.path + 'exercises/'
        when ExposedLinux::Exercise
          path(obj.dojo.exercises) + obj.name + '/'
        when ExposedLinux::Katas
          obj.dojo.path + 'katas/'
        when ExposedLinux::Kata
          path(obj.dojo.katas) + obj.id[0..1] + '/' + obj.id[2..-1] + '/'
        when ExposedLinux::Avatar
          path(obj.kata) + obj.name + '/'
        when ExposedLinux::Sandbox
          path(obj.avatar) + 'sandbox/'
      end
    end

  private

    def is_dir?(name)
      File.directory?(name) && !name.end_with?('.') && !name.end_with?('..')
    end

  end

end


# idea is that this will hold methods that forward to external
# services namely: disk, git, shell.
# And I will create another implementation IsolatedDockerPaas
# Design notes
#
# o) locking is not right.
#    I need a 'Paas::Session' object which can scope the lock/unlock
#    over a sequence of actions. The paas object can hold this itself
#    since a new Paas object is created for each controller-action
#    CHECK THAT IS INDEED TRUE and that the same paas object is remembered
#    inside the controller
#         def paas
#           @paas ||= expression
#         end
#
# o) IsolatedDockerPaas.disk will have smarts to know if reads/writes
#    are local to disk (eg exercises) or need to go into container.
#    ExposedLinuxPaas.disk can have several dojos (different root-dirs eg testing)
#    so parent refs need to link back to dojo which
#    will be used by paas to determine paths.
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
