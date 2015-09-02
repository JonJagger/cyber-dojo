
require_relative 'Runner'
require_relative 'Stderr2Stdout'

# Assumes:
#   @bash.exec(cmd)
#   @cid_filename
#   sudoi(cmd)

module DockerTimesOutRunner # mix-in

  def runnable?(language)
    image_names.include?(language.image_name)
  end

  module_function

  include Runner
  include Stderr2Stdout

  def raise_if_docker_not_installed
    raise RuntimeError.new('Docker not installed') if !installed?
  end

  def installed?
    _,exit_status = bash(sudoi('docker info'))
    exit_status === 0
  end

  def image_names
    @image_names ||= read_image_names
  end

  def read_image_names
    output,_ = bash(sudoi('docker images'))
    lines = output.split("\n").select{|line| line.start_with?('cyberdojo')}
    image_names = lines.collect{|line| line.split[0]}
  end

  def times_out_run(options, image_name, cmd, max_seconds)
    bash("rm -f #{@cid_filename}")
    outer_command = timeout(
      'docker run' +
      ' --user=www-data' +
      " --cidfile=#{quoted(@cid_filename)}" +
      " #{options.strip}" +
      " #{image_name}" +
      " /bin/bash -c #{quoted(cmd)}",
      max_seconds+5)

    output,exit_status = bash(sudoi(outer_command))
    pid,_ = bash("cat #{@cid_filename}")
    bash(sudoi("docker stop #{pid}"))
    bash(sudoi("docker rm #{pid}"))
    exit_status != fatal_error(kill) ? limited(output) : didnt_complete(max_seconds)
  end

  def bash(command)
    @bash.exec(command)
  end

  def quoted(arg)
    '"' + arg + '"'
  end

  def timeout(command,secs)
    "timeout --signal=#{kill} #{secs}s #{stderr2stdout(command)}"
  end

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# "docker run" +
#    " -u www-data" +
#    " --cidfile=#{quoted(cidfile)}" +
#    ...
#    " /bin/bash -c #{quoted(cmd)}"
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# -u www-data
#
#   The user which runs the inner_command *inside* the docker container.
#   See comments in languages/C#/NUnit/Dockerfile
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --cidfile=#{quoted(@cidfile)}
#
#   The cidfile must *not* exist before the docker command is run.
#   Thus I rm the cidfile *before* the docker run.
#   After the docker run I retrieve the docker container's pid
#   from the cidfile and stop and kill the container.
#   Explicitly specifying the cidfile like this (and not using the
#   docker --rm option) ensures the docker container is always killed,
#   even if the timeout occurs.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# image_name
#
#   The name of the docker image to run the inner-command inside.
#   specified in the language's manifest as its image_name.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# /bin/bash -c #{quoted(cmd)}"
#
#   The command that is run as the docker container's "main" is
#   run via bash. If the caller wants this to have a timeout
#   they must write the timeout.
#   Regardless, the outer docker-run command always has a timeout.
#   This is for extra security - a determined attacker might somehow kill
#   the inner timeout and thus acquire unlimited time to run any command.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


