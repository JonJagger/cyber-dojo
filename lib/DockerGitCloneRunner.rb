
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on git clone to give state access
# to docker process containers.

require_relative 'Runner'

class DockerGitCloneRunner

  def initialize(bash = Bash.new)
    @bash = bash
    raise RuntimeError.new("Docker not installed") if !installed?
  end

  def runnable?(language)    
    language.support_filenames != []
  end

  def run(sandbox, command, max_seconds)
    # git commit local changes
    # git push to git server
    # docker run ‘git clone git@IP:/opt/git/ID_lion.git && cd ID_lion && ./cyber-dojo.sh’
    #
    # Note: the git-server sees the git repo of the animal which is at the
    # folder level of the animal and not sandbox.
    # It would be best if the docker process container was somehow
    # restricted and could not [cd ..] to gain access to the
    # animal folder and potentially cause mischief. Viz it would
    # see the sandbox folder as its root (like DockerVolumeMountRunner)
    #
    # Should run(sandbox,...) be run(avatar,...)?  I think so.
    #
    # Pull model code into Runner classes.
    # Capture commonality in Runner classes in included Runner.rb
  end

private
  
  include Runner  
  include Stderr2Stdout
   
  def bash(command)
    @bash.exec(command)
  end

  def installed?
    _,exit_status = bash(stderr2stdout('docker info > /dev/null'))
    exit_status === 0
  end

end

