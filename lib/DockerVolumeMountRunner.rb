
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on volume mounts on local hard disk to
# give state access to docker process containers.
#
# Comments at end of file

require_relative 'DockerTimesOutRunner'
require 'tempfile'

class DockerVolumeMountRunner

  def initialize(bash = Bash.new, cid_filename = Tempfile.new('cyber-dojo').path)
    @bash,@cid_filename = bash,cid_filename
    raise_if_docker_not_installed
  end

  def runnable?(language)
    image_pulled?(language)
  end

  def started(avatar); end

  def run(sandbox, command, max_seconds)
    read_write = 'rw'
    sandbox_volume = "#{sandbox.path}:/sandbox:#{read_write}"
    options =
        ' --net=none' +
        " -v #{quoted(sandbox_volume)}" +
        ' -w /sandbox'
    cmd = timeout(command,max_seconds)
    language = sandbox.avatar.kata.language
    times_out_run(options, language.image_name, cmd, max_seconds)
  end

private

  include DockerTimesOutRunner

  def sudoi(cmd)
    cmd
  end

end


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    ' --net=none' +
#    " -v #{quoted(sandbox_volume)}" +
#    " -w /sandbox" +
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --net=none
#
#   Turn off all networking inside the container.
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

