
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# comments at end of file

require_relative 'TestRunner'
require 'tempfile' # Dir::Tmpname

class DockerTestRunner
    include TestRunner

  def initialize
    raise RuntimeError.new("Docker not installed") if !installed?    
    command = stderr2stdout('docker images')
    @image_names = DockerTestRunner.image_names(`#{command}`)
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
    language_volume = "#{language.path}:#{language.path}:#{read_only}"
    sandbox_volume = "#{sandbox.path}:/sandbox:#{read_write}"
    
    docker_command =
      "docker run" +
        " -u www-data" +
        " --net=#{quoted('none')}" +
        " --cidfile=#{quoted(cidfile)}" +
        " -v #{quoted(language_volume)}" +
        " -v #{quoted(sandbox_volume)}" +
        " -w /sandbox" +
        " #{language.image_name}" +
        " /bin/bash -c" +
        " #{quoted(command)}"
        
    outer_command = timeout(docker_command,max_seconds+5)
    output = `#{outer_command}`
    exit_status = $?.exitstatus

    pid = `cat #{cidfile}`
    `rm #{cidfile} ; docker stop #{pid} ; docker rm #{pid}`

    exit_status != fatal_error(kill) ?
        limited(clean(output),50*1024) :
        didnt_complete(max_seconds)
  end

  def self.image_names(output)
    output.split("\n")[1..-1].collect{|line| line.split[0]}.sort.uniq
  end

private

  include Cleaner

  def timeout(command,after)
    # I put a timeout on the outer docker-run command and not on 
    # the inner bash -c command. This is for security. If it was
    # on the inner bash -c command then a determined attacker might
    # kill the timeout but not the timed-task and thus acquire 
    # unlimited time to run any command.
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

  def installed?
    command = stderr2stdout('docker info > /dev/null')
    `#{command}`
    $?.exitstatus === 0
  end

  def stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

end


# docker run
#    " -u www-data" +
#    " --net=#{quoted('none')}" +
#    " --cidfile=#{quoted(cidfile)}" +
#    " -v #{quoted(language_volume)}" +
#    " -v #{quoted(sandbox_volume)}" +
#    " -w /sandbox" +
#    " #{language.image_name}" +
#    " /bin/bash -c" +
#    " #{quoted(command)}"
#
# -u www-data
#   The user which runs the inner_command *inside* the docker container.
#   See comments in languages/C#-NUnit/Dockerfile
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
#   timeout occurs.
#
# -v #{quoted(language_volume)}
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
# -v #{quoted(sandbox_volume)}
#   Volume mount the animal's sandbox to /sandbox inside the docker 
#   container as a read-write folder. This provides isolation.
#   Important to quote the volume incase any paths contain spaces
#
# -w /sandbox
#   Working directory when the command is run is /sandbox
#   (as volume mounted in the first -v option)
#
# #{language.image_name}
#   The name of the docker image to run the inner-command inside.
#   specified in the language's manifest as its image_name.
#
# /bin/bash -c #{quoted(command)}
#   The command that is run as the docker container's "main" is always
#   './cyber-dojo.sh' which is run via bash inside a timeout.
#
