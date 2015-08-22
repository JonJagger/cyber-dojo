
# Commonality from DockerGitCloneRunner and DockerVolumeMountRunner 

require_relative 'Runner'
require_relative 'Stderr2Stdout'

class DockerRunner

  def initialize(bash, cid_filename)
    @bash,@cid_filename = bash,cid_filename
    raise RuntimeError.new('Docker not installed') if !installed?
    output,_ = bash(sudoi('docker images'))
    lines = output.split("\n").select{|line| line.start_with?('cyberdojo')}
    @image_names = lines.collect{|line| line.split[0]}
  end
  
  attr_reader :image_names

  def image_pulled?(language)
    @image_names.include?(language.image_name)
  end

  def approval_test?(language)
    language.display_name.end_with?('Approval')
  end

  def sym_linked?(language)
    language.support_filenames != []
  end

  def docker_run(options, image_name, cmd, max_seconds)

    bash("rm -f #{@cid_filename}")

    # In a docker-swarm this needs to be as follows
    #
    # Note: outer timeout goes on docker run and not on sudo
    # Note: there is *no* timeout(cmd) because cmd is comprised
    #       of two ; separated commands and only (part of) the
    #       the last one needs the timeout wrapper
    # Note: the cyber-dojo user is assumed to have their
    #       docker-machine environment variables setup
    #       See notes/scaling/setup-cyber-dojo-user.txt
    #
=begin
    outer_command =
      'sudo -u cyber-dojo -i' +
      ' ' + timeout(
              ' docker run' +
              ' --user=www-data' +
              " --cidfile=#{quoted(cidfile)}" +
              ' ' + options +
              ' ' + image_name +
              " /bin/bash -c #{quoted(cmd)}",
              max_seconds+5)

    output,exit_status = bash(outer_command)
    pid,_ = bash("cat #{cidfile}")
    bash("sudo -u cyber-dojo -i docker stop #{pid}")
    bash("sudo -u cyber-dojo -i docker rm   #{pid}")
    # I can't figure out why the stop/rm have to split but they do
    exit_status != fatal_error(kill) ? limited(output) : didnt_complete(max_seconds)
=end

    outer_command = timeout(
      'docker run' +
      ' --user=www-data' +
      " --cidfile=#{quoted(@cid_filename)} " +
      ' ' + options +
      ' ' + image_name +
      " /bin/bash -c #{quoted(cmd)}",
      max_seconds+5)

    output,exit_status = bash(outer_command)
    pid,_ = bash("cat #{@cid_filename}")
    bash("docker stop #{pid} ; docker rm #{pid}")
    exit_status != fatal_error(kill) ? limited(output) : didnt_complete(max_seconds)
  end

  def bash(command)
    @bash.exec(command)
  end

  def quoted(arg)
    '"' + arg + '"'
  end

private
  
  include Runner  
  include Stderr2Stdout
   
  def installed?
    _,exit_status = bash(sudoi('docker info > /dev/null'))
    exit_status === 0
  end

  def timeout(command,after)
    "timeout --signal=#{kill} #{after}s #{stderr2stdout(command)}"
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
#    " /bin/bash -c #{quoted(timeout(command,max_seconds))}"
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
# --cidfile=#{quoted(cidfile)}
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
# /bin/bash -c #{quoted(timeout(command,max_seconds))}"
#
#   The command that is run as the docker container's "main" is
#   run via bash inside a timeout.
#   I *also* put a timeout on the outer docker-run command.
#   This is for security - a determined attacker might somehow kill
#   the inner timeout and thus acquire unlimited time to run any command.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


