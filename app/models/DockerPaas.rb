
# Paas on top of Docker: http://www.docker.io/
# provides security and isolation.

class DockerPaas

  def initialize(disk)
    @disk = disk
    @cids = [ ]
    # at end of docker-transaction *all*
    # cids inside @cids need to be deleted with `docker rm #{@cids.join(' ')}`
    # Note that if a container is used to create an image
    # then the container still needs to be deleted.
    # I choose not to do this...
    #   docker ps -a -q | xargs docker rm
    # as that way two sessions could both try to delete the same containers.
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def create_dojo(root, format)
    Dojo.new(self, root, format)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

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

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def make_kata(dojo, language, exercise, id, now)
    # this will need to find the docker-image for the language
    # language image could have familiar folder structure inside itself...
    #    var/www/cyberdojo/languages/NAME/manifest.json
    #    var/www/cyberdojo/languages/NAME/cyber-dojo.sh

    manifest = make_kata_manifest(dojo, language, exercise, id, now)
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = exercise.instructions

    kata = Kata.new(dojo, id)
    disk_write(kata, kata.manifest_filename, manifest)
    `sudo docker commit #{@cids.last} kata_#{kata.id}`
    kata
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # exists?

  def exists?(object)
    # this will need to check the result of `docker images`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # each() iteration

  def languages_each(languages)
    # iterate through a docker languages-registry
    # txt = `docker images`
    # iterate through docker registry for images starting 'language_'
    #
    # Or, create images and push them to cyberdojo user on https://index.docker.io/
    # sudo docker commit $CONTAINER_ID cyberdojo/perl
    # sudo docker push cyberdojo/perl
    # then
    # sudo docker search cyberdojo
    # No.
    # That is separate functionality. Checking if new language image
    # exists in the cyberdojo index.
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
    # txt = `docker images`
    # find any starting 'kata_'
  end

  def avatars_each(kata)
    # txt = `docker images`
    # find any starting 'kata_' + kata.id + '_avatar_'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def start_avatar(kata, avatar_names)
    # image = 'kata_' + kata.id
    # @cids << image

    avatar = nil
    started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
    unstarted_avatar_names = avatar_names - started_avatar_names
    if unstarted_avatar_names != [ ]
      avatar_name = unstarted_avatar_names[0]
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
        # But does symlinking save disk-space?
        # Why do a move/link at all?
        # Why not just rename the underlying folder!
        # We're in a new image!
      end

      avatar.commit(tag=0)
    end
    `docker commit #{@cids.last} avatar_#{kata.id}_#{avatar.name}_0`
    avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # disk-helpers

  #def disk_make_dir(object)
  #  LinuxPaas also has this.
  #  Uses in start_avatar() only
  #end

  def disk_read(object, filename)
    docker(object, "cat '#{filename}'")
  end

  def disk_write(object, filename, content)
    # There is a whole lot of extra stuff that LinuxPaas does here via OsDir
    # Viz makes the directory
    #     saves content.inspect if filename.end_with? '.rb'
    #     saves JSON.unparse(content) if filename.end_with? '.json'
    #     chmod +x filename if filename.end_with? '.sh'
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

  def cid_filename(object)
    # TODO: don't use deeply nested path. Use a single name based
    #       on the object as the cidfile inside a cid dir.
    #       eg kata_2345612AE2.cid
    #       eg kata_2345612AE2_lion.cid
    #       make sure the cidfile is deleted at end of session.
    `mkdir -p #{path(object)}`
    name = path(object) + 'docker.cid'
    # docker run command complains if cidfile already exists
    `rm -f #{name}`
    name
  end

  def current_image_for(object)
    if @cids == [ ]
      # the initial image for object
      # mostly object == avatar, but can be eg kata-id (if creating avatar or dashboard)
      'to-do'
    else
      @cids.last
    end
  end

  # TODO: this is external. Needs to be injected from outside.
  # TODO: don't think the sudo will be needed if www-data is in docker group
  def docker(object, command, pre_pipe = "")
    image = current_image_for(object)
    cidfile = cid_filename(object)
    dir = path(object)
    command = "cd #{dir};" + command
    result = `#{pre_pipe} docker run --cidfile #{cidfile} -w #{dir} -i #{image} /bin/bash -c "#{command}"`
    cid = `cat #{cidfile}`
    `docker commit #{cid} #{cid}`
    @cids << cid
    result
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # image will be called something like 'avatar_BCE34DE552_cheetah'
  # and will mimic LinuxPaas dir structure.
  # Viz   /var/www/cyberdojo/katas/BC/E34DE552/cheetah
  # This should help when .tar.gz files are created and merged.

  def path(obj)
    case obj
      when Languages
        root + 'languages/'
      when Language
        path(obj.dojo.languages) + obj.name + '/'
      when Exercises
        root + 'exercises/'
      when Exercise
        path(obj.dojo.exercises) + obj.name + '/'
      when Katas
        root + 'katas/'
      when Kata
        path(obj.dojo.katas) + obj.id[0..1] + '/' + obj.id[2..-1] + '/'
      when Avatar
        path(obj.kata) + obj.name + '/'
      when Sandbox
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
    '/var/www/cyberdojo/'
  end

end

# idea is that this will hold methods that forward to external
# services namely: disk, git, shell.
# And I will create another implementation IsolatedDockerPaas
# Design notes
#
# o) PaasSession
#    I need a session-object which can scope the lock/unlock
#    over a sequence of actions. And also ensure the temporary
#    containers are deleted. The paas object can hold this itself
#    since a new Paas object is created for each controller-action
#    CHECK THAT IS INDEED TRUE and that the same paas object is remembered
#    inside the controller
#         def paas
#           @paas ||= expression
#         end
#    Design for this will be via a Proc, similar to how I did the
#    file locking - so it can have an ensure block which deleted
#    all the temporary containers. Note that even read-operations
#    on the current image will generate a new container.
#    Note that the idea of a session is also useful for plain LinuxPaas
#    for locking.
#
#    def session(object, &block)
#      raise exception if @paas != nil
#      raise exception if @cids != nil
#      @paas = ...
#      @cids = [ current_image_for(object) ]
#      begin
#        block.call()
#      ensure
#        teardown
#      end
#    end
#
#    I will need this at the start of every controller method.
#    Is there a way to do that automatically? Probably.
#
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
#
# o) MISC
#   https://blog.codecentric.de/en/2014/02/docker-registry-run-private-docker-image-repository/
#   Every single command in a Dockerfile yields a new Docker
#   image with an individual id similar to a commit in git.
#   This commit can be tagged for easy reference with a Docker Tag.
#   In addition, tags are the means to share images on public and private repositories.
#   You can tag any image with docker tag <image> <tag>.
#   The expression tag has evolved in Docker quite a lot and its meaning blurred.
#   The syntax for a tag is repository:[tag].
#   In general, a repository is a collection of images which are hosted in a registry.
#   docker tag --help
#   Usage: docker tag [OPTIONS] IMAGE [REGISTRYHOST/][USERNAME/]NAME[:TAGG
#
#   Note that images are different to containers.
#   I think every docker run command is on an image and creates a new container
#   The container has to be committed to an image to be able to run a new command
#   on top of it.
