
class DockerPaas

  def initialize(disk)
    @disk = disk
    @cids = [ ]
    # at end of docker-transaction
    #   all cids inside @cids need to be deleted
    #   that means images and containers
    #   Not ones that start with 'kata_' or 'avatar_'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def create_dojo(root, format)
    Dojo.new(self, root, format)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def make_kata(language, exercise, id, now)
    # this will need to find the image for the language
    # language image will have familiar folder structure...
    #    ~/cyberdojo/languages/NAME/manifest.json
    #    ~/cyberdojo/languages/NAME/cyber-dojo.sh

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

    disk_write(kata, kata.manifest_filename, manifest)
    `sudo docker commit #{@cids.last} kata_#{kata.id}`
    kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # each() iteration

  def languages_each(languages)
    # iterate through a docker languages-registry
    # txt = `sudo docker images`
    # iterate through docker registry for images starting 'language_'
    #
    # Or, create images and push them to cyberdojo user on https://index.docker.io/
    # sudo docker commit $CONTAINER_ID cyberdojo/perl
    # sudo docker push cyberdojo/perl
    # then
    # sudo docker search cyberdojo
    #
  end

  def exercises_each(exercises)
    # Keep on local disk?
    # Maybe later give Exercise a manifest like Language
    # and allow an Exercise image to have its own additional
    # set of exercises. This would work very well for James
    # for example.
    Dir.entries(path(exercises)).each do |name|
      yield name if is_dir?(File.join(path(exercises), name))
    end
  end

  def katas_each(katas)
    # txt = `sudo docker images`
    # iterate through local docker registry for images starting 'kata_'
  end

  def avatars_each(kata)
    # txt = `sudo docker images`
    # iterate through docker registry for images starting 'avatar_' + kata.id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def start_avatar(kata)
    # image = 'kata_' + kata.id
    # @cids << image

    avatar = nil
    started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = Avatar.names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names.shuffle[0]
      avatar = Avatar.new(kata,avatar_name)

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
        # I think this can just become a mv.
        # Files are not shared with anyone
        # else because of the union file system.
        #@disk.symlink(old_name, new_name)  <---------------------
      end

      avatar.commit(tag=0)
    end
    `sudo docker commit #{@cids.last} avatar_#{kata.id}_#{avatar.name}_0`
    avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # disk-helpers

  def disk_read(object, filename)
    docker(object, "cat '#{filename}'")
  end

  def disk_write(object, filename, content)
    docker(object, "cat > '#{filename}'", "echo '#{content}' | ")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # git-helpers

  def git_init(object, args)
    git_cmd(object, 'init', args)
  end

  def git_add(object, filename)
    git_cmd(object, 'add', args)
  end

  def git_rm(object, filename)
    git_cmd(object, 'rm', args)
  end

  def git_commit(object, args)
    git_cmd(object, 'commit', args)
  end

  def git_tag(object, args)
    git_cmd(object, 'tag', args)
    # I think this will be the last command
    # and so will require docker commit to new image
  end

  def git_diff(object, args)
    git_cmd(object, 'diff', args)
  end

  def git_show(object, args)
    git_cmd(object, 'show', args)
  end

  def git_cmd(object, cmd, args)
    docker(object, "git #{cmd} #{args}")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # runner-helper

  def runner_run(object, command, max_duration)
    docker(object, "timeout #{max_duration}s #{command}")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # docker-helpers
  # https://blog.codecentric.de/en/2014/02/docker-registry-run-private-docker-image-repository/
  # Every single command in a Dockerfile yields a new Docker
  # image with an individual id similar to a commit in git.
  # This commit can be tagged for easy reference with a Docker Tag.
  # In addition, tags are the means to share images on public and private repositories.
  # You can tag any image with docker tag <image> <tag>.
  # The expression tag has evolved in Docker quite a lot and its meaning blurred.
  # The syntax for a tag is repository:[tag].
  # In general, a repository is a collection of images which are hosted in a registry.

  def cid_filename(object)
    `mkdir -p #{path(object)}`
    name = path(object) + 'docker.cid'
    `rm -f #{name}`
    name
  end

  def docker(object, command, pre_pipe = "")
    image = @cids.last
    cidfile = cid_filename(object)
    dir = path(object)
    command = "cd #{dir};" + command
    result = `#{pre_pipe} sudo docker run --cidfile #{cidfile} -w #{dir} -i #{image} /bin/bash -c "#{command}"`
    cid = `cat #{cidfile}`
    `sudo docker commit #{cid} #{cid}`
    @cids << cid
    result
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # container will be called something like 'avatar_BCE34DE552_cheetah_0'
  # and will mimic ExposedLinux dir structure.
  # Viz   ~/cyberdojo/katas/BC/E34DE552/cheetah
  # This should help when .tar.gz files are created and merged.

  def path(obj)
    case obj
      when ExposedLinux::Languages
        root + 'languages/'
      when ExposedLinux::Language
        path(obj.dojo.languages) + obj.name + '/'
      when ExposedLinux::Exercises
        root + 'exercises/'
      when ExposedLinux::Exercise
        path(obj.dojo.exercises) + obj.name + '/'
      when ExposedLinux::Katas
        root + 'katas/'
      when ExposedLinux::Kata
        path(obj.dojo.katas) + obj.id[0..1] + '/' + obj.id[2..-1] + '/'
      when ExposedLinux::Avatar
        path(obj.kata) + obj.name + '/'
      when ExposedLinux::Sandbox
        path(obj.avatar) + 'sandbox/'
    end
  end

  def root
    # ??? is ~ path ok or does it have to start at /
    # and what user do I want the commands to be run under?
    # one option is to make usernames for each animal!
    # Quite like that. Suggests possibility of them talking
    # to each other. Note that a chat-like facility would need
    # a very different implementation because of the genuine
    # isolation.
    '~/cyberdojo/'
  end

private

  def is_dir?(name)
    File.directory?(name) && !name.end_with?('.') && !name.end_with?('..')
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
