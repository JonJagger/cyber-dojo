
# test runner providing isolation/protection/security
# via Docker containers https://www.docker.io/
# and relying on git clone from git-server to give state
# access to docker process containers.

require_relative 'Runner'

class DockerGitCloneRunner

  def initialize(bash = Bash.new)
    @bash = bash
    raise RuntimeError.new("Docker not installed") if !installed?
  end

  def runnable?(language)    
    language.support_filenames != [] &&
      !language.display_name.end_with?('Approval')
  end

  def git_server
    "192.168.59.104"
  end
  
  def started(avatar)
    # remote = "#{avatar.kata.id}_#{avatar.name}.git"
    # NOTE: bare remote needs to go to Temp folder
    # git clone --bare "#{avatar.path}" "#{remote}"
    # scp -r #{remote} git@#{git_server}:/opt/git
    # NOTE: bare remote in Temp folder needs deleting
  end
  
  def pre_test(avatar)
    # git.commit(avatar.path, "-a -m 'pre-push' --quiet")
    # git.push(avatar.path)
  end
  
  def post_commit_tag(avatar)
    # git.push(avatar.path)
  end

  def run(sandbox, command, max_seconds)
    # 
    # ip = "...."
    # id = avatar.kata.id.to_s
    # cmd = "git clone git@#{git_server}:/opt/git/#{id}_#{avatar.name}.git"
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
    # Note: will be worth extracting DockerRunner that just does run()
    #       into dedicated class.
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

