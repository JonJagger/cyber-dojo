
# docker runner 
# Assumes docker run command does not have --rm option
# and does have --cidfile=quoted(cidfile) option

require_relative 'Runner'
require_relative 'Stderr2Stdout'
require 'tempfile'

class DockerRunner

  def initialize(bash = Bash.new)
    @bash = bash
    raise RuntimeError.new("Docker not installed") if !installed?        
  end
  
  def docker_run(cmd, options, max_seconds)
    cidfile = Tempfile.new('cyber-dojo').path
    outer_command = timeout(
      'docker run' +
      " --cidfile=#{quoted(cidfile)} " + 
      options +
      " /bin/bash -c #{quoted(timeout(cmd,max_seconds))}", 
      max_seconds+5)
    bash("rm -f #{cidfile}")
    output,exit_status = bash(outer_command)
    pid,_ = bash("cat #{cidfile}")
    bash("docker stop #{pid} ; docker rm #{pid}")
    exit_status != fatal_error(kill) ? limited(output) : didnt_complete(max_seconds)
  end

  def bash(command)
    @bash.exec(command)
  end

private
  
  include Runner  
  include Stderr2Stdout
   
  def installed?
    _,exit_status = bash(stderr2stdout('docker info > /dev/null'))
    exit_status === 0
  end
   
  def timeout(command,after)
    # timeout does not exist on OSX :-(
    "timeout --signal=#{kill} #{after}s #{stderr2stdout(command)}"
  end

  def fatal_error(signal)
    128 + signal
  end

  def kill
    9
  end

end

