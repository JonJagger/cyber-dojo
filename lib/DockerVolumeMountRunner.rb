
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on volume mounts on local hard disk to
# give state access to docker process containers.
#
# Comments at end of file

require_relative 'DockerRunner'

class DockerVolumeMountRunner < DockerRunner

  def initialize(bash = Bash.new)
    super(bash)
  end

  def runnable?(language)
    image_pulled?(language) &&
      !approval_test?(language)
  end

  def started(avatar); end

  def pre_test(avatar); end

  def run(sandbox, command, max_seconds)
    language = sandbox.avatar.kata.language
    read_only = 'ro'
    language_volume = "#{language.path}:#{language.path}:#{read_only}"
    read_write = 'rw'
    sandbox_volume = "#{sandbox.path}:/sandbox:#{read_write}"

    options =
        " --net=#{quoted('none')}" +
        " -v #{quoted(language_volume)}" +
        " -v #{quoted(sandbox_volume)}" +
        ' -w /sandbox'

    docker_run(options, language.image_name, command, max_seconds)
  end

private

  def sudoi(s)
    s
  end

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    " --net=#{quoted('none')}" +
#    " -v #{quoted(language_volume)}" +
#    " -v #{quoted(sandbox_volume)}" +
#    " -w /sandbox" +
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --net="none"
#
#   Turn off all networking inside the container.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -v #{quoted(language_volume)}
#
#   Volume mount the language's folder to the same folder inside
#   the docker container. Intermediate folders are created as necessary
#   (like mkdir -p). This provides access to supporting files which
#   were sym-linked from the animal's sandbox when the animal started.
#   Not all languages have symlinks but it's simpler to just do it anyway.
#   Mounted as a read-only volume since these support files are shared
#   by all animals in all katas that choose that language.
#   Important to quote the volume incase any paths contain spaces
#   eg languages/C (gcc)/
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -v #{quoted(sandbox_volume)}
#
#   Volume mount the animal's sandbox to /sandbox inside the docker
#   container as a read-write folder. This provides isolation.
#   Important to quote the volume incase any paths contain spaces
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -w /sandbox
#
#   Working directory when the command is run is /sandbox
#   (as volume mounted in the first -v option)
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

