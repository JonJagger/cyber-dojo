
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
    # git.commit(avatar.path, "-a -m 'pre-push' --quiet")
    # git.push(avatar.path, "origin master")
    # 
    # ip = "...."
    # id = avatar.kata.id.to_s
    # cmd = "git clone git@#{ip}:/opt/git/#{id}_#{avatar.name}.git"
    # cmd += "&& cd #{avatar.name}"
    # cmd += "&& ./cyber-dojo.sh"
    # docker run #{cmd}
    #
    # Note: the git-server sees the git repo of the animal which is at the
    # folder level of the animal and not sandbox.
    # But this is ok. Even if the cyber-dojo.sh tries to [cd ..]
    # and cause mischief any problems are localized since only
    # the output comes back to the rails server.
    #
    # Note: Should run(sandbox,...) be run(avatar,...)?  I think so.
    #
    # Note: command being passed in allows extra testing options.
    #
    # Note: will be worth extracting DockkerRunner that just does run()
    #       into dedicted class.
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

