
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/

require_relative 'TestRunner'
require 'tempfile' # Dir::Tmpname

class DockerTestRunner
    include TestRunner

  def initialize
    command = stderr2stdout('docker images')
    @image_names = image_names(`#{command}`)
  end

  def runnable?(language)
    @image_names.include?(language.image_name)
  end

  def run(sandbox, command, max_seconds)
    inner_run(sandbox, timeout(command,max_seconds), max_seconds)
  end

  def inner_run(sandbox, command, max_seconds)
    cidfile = Dir::Tmpname.create(['cidfile', '.txt']) {}

    language = sandbox.avatar.kata.language
    docker_command =
      "docker run" +
        " -u www-data" +
        " --net=#{quoted('none')}" +
        " --cidfile=#{quoted(cidfile)}" +
        " -v #{sandbox.path}:/sandbox:#{read_write}" +
        " -v #{language.path}:#{language.path}:#{read_only}" +
        " -w /sandbox" +
        " #{language.image_name}" +
        " /bin/bash -c" +
        " #{quoted(command)}"
    outer_command = timeout(docker_command,max_seconds+5)

    output = `#{outer_command}`
    exit_status = $?.exitstatus

    pid = `cat #{cidfile}`
    `rm #{cidfile}`
    `docker stop #{pid}`
    `docker rm #{pid}`

    exit_status != fatal_error(kill) ?
        limited(output,50*1024) :
        didnt_complete(max_seconds)
  end

  def image_names(output)
    output.split("\n")[1..-1].collect{|line| line.split[0]}.sort.uniq
  end

private

  def timeout(command,after)
    "timeout --signal=#{kill} #{after}s #{stderr2stdout(command)}"
  end

  def quoted(arg)
    '"' + arg + '"'
  end

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

  def read_write
    'rw'
  end

  def read_only
    'ro'
  end

end


# docker run
#    " -u www-data" +
#    " --net=#{quoted('none')}" +
#    " --cidfile=#{quoted(cidfile)}" +
#    " -v #{sandbox.path}:/sandbox:#{read_write}" +
#    " -v #{language.path}:#{language.path}:#{read_only}" +
#    " -w /sandbox" +
#    " #{language.image_name}" +
#    " /bin/bash -c" +
#    " #{quoted(command)}"
#
# -u www-data
#   The user which runs the inner_command *inside* the docker container.
#   A few docker containers are sensitive about the specific user which
#   *must* be www-data. These are the mono based ones:
#   C#-NUNit, C#-Specflow, F#-NUnit
#   This is because NUnit requires write access to the users
#   $HOME directory. If you run with a user that does not have
#   $HOME setup it will probably default to / and you won't have rights.
#   See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638337
#
# --net="none"
#   Turn off all networking inside the container.
#
# --cidfile=#{quoted(cidfile)}
#   I do not use the --rm command. Instead I specify the name
#   of a unique cidfile (which must not exist before the docker
#   command is run) from which I retrieve the docker container's
#   pid and then stop and kill the container. This ensures
#   that the docker container is always killed, even if the
#   outer timeout occurs.
#
# -v #{sandbox.path}:/sandbox:#{read_write}
#   Volume mount the animal's sandbox to /sandbox inside the container
#   as a read-write folder. This provides isolation.
#
# -v #{language.path}:#{language.path}:#{read_only}
#   Volume mount the language's folder to the same folder path+name
#   inside the container. Intermediate folders are created as necessary
#   (like mkdir -p). This provides access to supporting files which
#   were sym-linked from the animal's sandbox when the animal started.
#   Not all languages have symlinks but it's simpler to just do it anyway.
#   Mounted as a read-only volume since these support files are shared
#   by all animals in all katas that choose that language.
#
# -w /sandbox
#   Working directory when the command is run is /sandbox
#   (as volume mounted in the first -v option)
#
# #{language.image_name}
#   The name of the docker container to run the inner-command inside.
#   specified in the language's manifest as its image_name.
#
# /bin/bash -c #{quoted(command)}
#   The command that is run inside the docker container is always
#   './cyber-dojo.sh' which is run via bash inside a timeout.
#
