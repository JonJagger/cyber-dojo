
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
    "git@192.168.59.103"
  end

  def kata_path(kata)
    id = kata.id.to_s
    outer = id[0..1]
    inner = id[2..-1]
    "/opt/git/#{outer}/#{inner}"
  end
  
  def started(avatar)
    kata = avatar.kata
  
    cmds = [
      "cd #{kata.path}",
      "git clone --bare #{avatar.name} #{avatar.name}.git",
      "sudo -u cyber-dojo ssh #{git_server} 'mkdir -p #{kata_path(kata)}'",
      "sudo -u cyber-dojo scp -r #{avatar.name}.git #{git_server}:#{kata_path(kata)}",
      "rm -rf #{avatar.name}.git",
      "cd #{avatar.path}",
      "git remote add master #{git_server}:#{kata_path(kata)}/#{avatar.name}.git",
      "sudo -u cyber-dojo git push --set-upstream master master"
    ]
    o,es = bash(cmds.join(';'))
  end
  
  def pre_test(avatar)
    # git.commit(avatar.path, "-a -m 'pre-push' --quiet")
    # git push has to be done with
    #    sudo -u cyber-dojo ...
    # git.push(avatar.path)
  end
  
  def post_commit_tag(avatar)
    # git push has to be done with 
    #    sudo -u cyber-dojo ...
    # git.push(avatar.path)
  end

  def run(sandbox, command, max_seconds)
    avatar = sandbox.avatar
    kata = avatar.kata
    # cmd = ""
    # cmd += "git clone #{git_server}:#{kata_path(kata)}/#{avatar.name}.git"
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

