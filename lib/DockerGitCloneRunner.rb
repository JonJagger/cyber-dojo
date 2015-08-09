
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
    language.support_filenames == [] &&
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
      # scp -r says it makes directories as needed but it doesn't seem to
      # which is why I'm preceding the scp with the mkdir -p
      "sudo -u cyber-dojo ssh #{git_server} 'mkdir -p #{kata_path(kata)}'",
      "sudo -u cyber-dojo scp -r #{avatar.name}.git #{git_server}:#{kata_path(kata)}",
      # allow git-daemon to serve it
      "sudo -u cyber-dojo ssh #{git_server} 'touch #{kata_path(kata)}/#{avatar.name}.git/git-daemon-export-ok'",
      "rm -rf #{avatar.name}.git",
      "cd #{avatar.path}",
      "git remote add master #{git_server}:#{kata_path(kata)}/#{avatar.name}.git",
      "sudo -u cyber-dojo git push --set-upstream master master"
    ].join(';')
    o,es = bash(cmds)
  end
  
  def pre_test(avatar)
    # if no visible files have changed this will be a no-op
    cmds = [
      "cd #{avatar.path}",
      "sudo -u cyber-dojo git commit -am 'pre-test-push' --quiet"
      "sudo -u cyber-dojo git push master"
    ].join(';')
    o,es = bash(cmds)
  end
  
  def post_commit_tag(avatar)
    cmd = [
      "sudo -u cyber-dojo git push master"
    ]
    o,es = bash(cmd)
  end

  def run(sandbox, command, max_seconds)
    avatar = sandbox.avatar
    kata = avatar.kata
    cidfile = avatar.path + 'cidfile.txt'
    language = kata.language

    # Unless the docker container has ssh credentials
    # this will require entering the git password.
    # Better option I think is to set up a git daemon on 
    # the git server.
    cmds = [
      "git clone #{git_server}:#{kata_path(kata)}/#{avatar.name}.git",
      "cd #{avatar.name}/sandbox",
      "#{command}"
    ].join(';')
    
    # network defaults to bridged. Would prefer it
    # if I could restrict it soley to the git server.
    docker_cmd = 
      "docker run" +
      " -u www-data" +
      " --cidfile=#{quoted(cidfile)}" +
      " #{language.image_name}" +
      " /bin/bash -c" +
      " #{quoted(timeout(cmd,max_seconds))}"
      
    outer_command = timeout(docker_command,max_seconds+5)

    bash("rm -f #{cidfile}")
    output,exit_status = bash("#{outer_command}")
    pid,_ = bash("cat #{cidfile}")
    bash("docker stop #{pid} ; docker rm #{pid}")

    exit_status != fatal_error(kill) ? limited(output) : didnt_complete(max_seconds)
      
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

