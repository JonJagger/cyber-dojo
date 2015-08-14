
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

  def run(sandbox, command, max_seconds)
    language = sandbox.avatar.kata.language
    read_only = 'ro'
    language_volume = "#{language.path}:#{language.path}:#{read_only}"
    read_write = 'rw'
    sandbox_volume = "#{sandbox.path}:/sandbox:#{read_write}"

    options =
        " --net=#{quoted(none)}" +
        " -v #{quoted(language_volume)}" +
        " -v #{quoted(sandbox_volume)}" +
        ' -w /sandbox'

    docker_run(options, language.image_name, command, max_seconds)
  end

private
  
  def none
    'none'
  end

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    " -u www-data" +
#    " --net=#{quoted('none')}" +
#    " --cidfile=#{quoted(cidfile)}" +
#    " -v #{quoted(language_volume)}" +
#    " -v #{quoted(sandbox_volume)}" +
#    " -w /sandbox" +
#    " #{language.image_name}" +
#    " /bin/bash -c" +
#    " #{quoted(timeout(command,max_seconds))}"
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -u www-data
#
#   The user which runs the inner_command *inside* the docker container.
#   See comments in languages/C#-NUnit/Dockerfile
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --net="none"
#
#   Turn off all networking inside the container.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --cidfile=#{quoted(cidfile)}
#
#   I use a cidfile in the avatars folder (and not its sandbox folder)
#   to avoid  potential clash with a visible_file with the same name.
#   The cidfile must not exist before the docker command is run.
#   Thus I rm the cidfile *before* the docker run.
#   After the docker run I retrieve the docker container's pid
#   from the cidfile and stop and kill the container.
#   Explicitly specifying the cidfile like this (and not using the
#   docker --rm option) ensures the docker container is always killed,
#   even if the timeout occurs.
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
#   eg languages/C++ (clang++)/
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
#
# #{language.image_name}
#
#   The name of the docker image to run the inner-command inside.
#   specified in the language's manifest as its image_name.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# /bin/bash -c #{quoted(timeout(command,max_seconds))}"
#
#   The command that is run as the docker container's "main" is always
#   './cyber-dojo.sh' which is run via bash inside a timeout.
#   I *also* put a timeout on the outer docker-run command.
#   This is for security - a determined attacker might somehow kill
#   the inner timeout and thus acquire  unlimited time to run any command.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

